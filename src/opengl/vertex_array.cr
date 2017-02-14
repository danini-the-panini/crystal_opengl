require "lib_gl"

module OpenGL
  class VertexArray
    @vao : LibGL::UInt

    def initialize
      LibGL.genVertexArrays(1, out vao)
      @vao = vao
    end

    def draw
      bind do
        LibGL.drawElements(LibGL::TRIANGLES,
                           3,
                           LibGL::UNSIGNED_INT,
                           Pointer(Void).new(0))
      end
    end

    def bind
      LibGL.bindVertexArray(@vao)
      ret = yield
      LibGL.bindVertexArray(0)
      ret
    end
  end
end
