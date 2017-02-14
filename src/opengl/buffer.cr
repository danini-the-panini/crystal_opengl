require "lib_gl"

module OpenGL
  class Buffer(T)
    @buffer : LibGL::UInt
    @target : UInt32
    @usage  : UInt32

    TARGETS = {
      array:              LibGL::ARRAY_BUFFER,
      atomic_counter:     LibGL::ATOMIC_COUNTER_BUFFER,
      copy_read:          LibGL::COPY_READ_BUFFER,
      copy_write:         LibGL::COPY_WRITE_BUFFER,
      dispatch_indirect:  LibGL::DISPATCH_INDIRECT_BUFFER,
      draw_indirect:      LibGL::DRAW_INDIRECT_BUFFER,
      element_array:      LibGL::ELEMENT_ARRAY_BUFFER,
      pixel_pack:         LibGL::PIXEL_PACK_BUFFER,
      pixel_unpack:       LibGL::PIXEL_UNPACK_BUFFER,
      query:              LibGL::QUERY_BUFFER,
      shader_storage:     LibGL::SHADER_STORAGE_BUFFER,
      texture:            LibGL::TEXTURE_BUFFER,
      transform_feedback: LibGL::TRANSFORM_FEEDBACK_BUFFER,
      uniform:            LibGL::UNIFORM_BUFFER
    }

    USAGES = {
      stream_draw:  LibGL::STREAM_DRAW,
      stream_read:  LibGL::STREAM_READ,
      stream_copy:  LibGL::STREAM_COPY,
      static_draw:  LibGL::STATIC_DRAW,
      static_read:  LibGL::STATIC_READ,
      static_copy:  LibGL::STATIC_COPY,
      dynamic_draw: LibGL::DYNAMIC_DRAW,
      dynamic_read: LibGL::DYNAMIC_READ,
      dynamic_copy: LibGL::DYNAMIC_COPY
    }

    def initialize(target, usage)
      @target = TARGETS[target]
      @usage = USAGES[usage]
      LibGL.genBuffers(1, out buffer)
      @buffer = buffer
    end

    def data=(data : Array(T))
      bind do
        LibGL.bufferData(@target, data.size * sizeof(T), pointerof(data).as(Void*), @usage)
      end
    end

    def bind
      LibGL.bindBuffer(@buffer, @target)
      yield
    end
  end
end
