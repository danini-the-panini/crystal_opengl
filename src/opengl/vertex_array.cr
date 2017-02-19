require "lib_gl"

module OpenGL
  class VertexArray
    @vao : LibGL::UInt

    MODES = {
      points:                   LibGL::POINTS,
      line_strip:               LibGL::LINE_STRIP,
      line_loop:                LibGL::LINE_LOOP,
      lines:                    LibGL::LINES,
      line_strip_adjacency:     LibGL::LINE_STRIP_ADJACENCY,
      lines_adjacency:          LibGL::LINES_ADJACENCY,
      triangle_strip:           LibGL::TRIANGLE_STRIP,
      triangle_fan:             LibGL::TRIANGLE_FAN,
      triangles:                LibGL::TRIANGLES,
      triangle_strip_adjacency: LibGL::TRIANGLE_STRIP_ADJACENCY,
      triangles_adjacency:      LibGL::TRIANGLES_ADJACENCY,
      patches:                  LibGL::PATCHES
    }

    def initialize
      LibGL.genVertexArrays(1, out vao)
      @vao = vao
      @enabled_attributes = {} of LibGL::Int => Bool
    end

    def draw_elements(buffer : Buffer, mode, number_of_elements = buffer.data.size)
      bind do
        buffer.bind do
          LibGL.drawElements(MODES[mode],
                             number_of_elements,
                             buffer.data_type,
                             nil)
        end
      end
    end

    def enable_attribute(index : LibGL::Int)
      LibGL.enableVertexArrayAttrib(@vao, index)
      @enabled_attributes[index] = true
    end

    def disable_attribute(index : LibGL::Int)
      LibGL.disableVertexArrayAttrib(@vao, index)
      @enabled_attributes[index] = false
    end

    def attribute_pointer(buffer : Buffer, index : LibGL::Int, size : LibGL::Int = 3, normalized : Bool = false, stride : LibGL::SizeI = 0)
      bind do
        if !@enabled_attributes[index]?
          LibGL.enableVertexAttribArray(index)
          @enabled_attributes[index] = true
        end
        buffer.bind do
          LibGL.vertexAttribPointer(index, size, buffer.data_type, normalized ? LibGL::TRUE : LibGL::FALSE, stride, nil)
        end
      end
    end

    def bind
      bind!
      ret = yield
      LibGL.bindVertexArray(0)
      ret
    end

    def bind!
      LibGL.bindVertexArray(@vao)
    end

    def to_unsafe
      @vao
    end

    def delete
      LibGL.deleteVertexArrays(1, pointerof(@vao))
    end

    def finalize
      delete
    end
  end
end
