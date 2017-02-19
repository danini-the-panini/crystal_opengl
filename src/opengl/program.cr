require "lib_gl"
require "./shader"
require "./program_uniform_methods"

module OpenGL
  class Program
    include ProgramUniformMethods

    @program : LibGL::UInt

    def initialize
      @program = LibGL.createProgram
      @uniforms = {} of String => LibGL::Int
      @attributes = {} of String => LibGL::Int
    end

    def attach(shader : Shader)
      LibGL.attachShader(@program, shader)
    end

    def link
      LibGL.linkProgram(@program)
      check_link_status
    end

    def delete
      LibGL.deleteProgram(@program)
    end

    def uniform_location(name : String)
      @uniforms[name] ||= LibGL.getUniformLocation(@program, name)
    end

    def attribute_location(name : String)
      @attributes[name] ||= LibGL.getAttribLocation(@program, name)
    end

    def use
      LibGL.useProgram(@program)
    end

    def finalize
      delete
    end

    def to_unsafe
      @program
    end

    private def check_link_status
      LibGL.getProgramiv(@program, LibGL::LINK_STATUS, out shader_ok)
      if shader_ok != LibGL::TRUE
        LibGL.getProgramiv(@program, LibGL::INFO_LOG_LENGTH, out log_length)
        log = Pointer(LibC::Char).malloc(log_length)
        LibGL.getProgramInfoLog(@program, log_length, nil, log)
        self.delete
        raise ProgramLinkingException.new(String.new(log, log_length))
      end
    end
  end

  class ProgramLinkingException < Exception
    getter :log

    def initialize(@log : String)
      super("Failed to link program:\n#{@log}")
    end
  end
end
