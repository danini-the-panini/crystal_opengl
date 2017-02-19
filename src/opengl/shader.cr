require "lib_gl"

module OpenGL
  class Shader
    @type : LibGL::Enum
    @source : String?
    @filename : String?
    @shader : LibGL::UInt

    TYPES = {
      vertex: LibGL::VERTEX_SHADER,
      fragment: LibGL::FRAGMENT_SHADER,
      geometry: LibGL::GEOMETRY_SHADER,
      compute: LibGL::COMPUTE_SHADER,
      tess_evaluation: LibGL::TESS_EVALUATION_SHADER,
      tess_control: LibGL::TESS_CONTROL_SHADER
    }

    def initialize(type)
      @type = TYPES[type]
      @shader = LibGL.createShader(@type)
      @source = nil
      @filename = nil
    end

    def source=(source : String)
      @source = source
      length = source.size
      source_string = source.to_unsafe
      LibGL.shaderSource(@shader, 1, pointerof(source_string), pointerof(length))
    end

    def source=(source : File)
      @filename = source.path
      self.source = source.gets_to_end
    end

    def compile
      LibGL.compileShader(@shader)
      check_compile_status
    end

    def delete
      LibGL.deleteShader(@shader)
    end

    def finalize
      delete
    end

    def to_unsafe
      @shader
    end

    private def check_compile_status
      LibGL.getShaderiv(@shader, LibGL::COMPILE_STATUS, out shader_ok)
      if shader_ok != LibGL::TRUE
        LibGL.getShaderiv(@shader, LibGL::INFO_LOG_LENGTH, out log_length)
        log = Pointer(LibGL::Char).malloc(log_length)
        LibGL.getShaderInfoLog(@shader, log_length, nil, log)
        self.delete
        raise ShaderCompilationException.new(String.new(log, log_length), @source, @filename)
      end
    end
  end

  class ShaderCompilationException < Exception
    getter :log, :filename, :source

    def initialize(@log : String, @source : String?, @filename : String? = nil)
      super("Failed to compile shader: #{@filename || "<unknown>"}:\n#{@log}")
    end
  end
end
