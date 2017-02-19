require "lib_gl"

module OpenGL
  class Buffer(T)
    @buffer    : LibGL::UInt
    @target    : LibGL::Enum
    @usage     : LibGL::Enum
    @data      : Array(T)
    @data_type : LibGL::Enum

    getter :data, :data_type

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

    TYPES = {
      Int32   => LibGL::INT,
      Int16   => LibGL::SHORT,
      Int8    => LibGL::BYTE,
      UInt32  => LibGL::UNSIGNED_INT,
      UInt16  => LibGL::UNSIGNED_SHORT,
      UInt8   => LibGL::UNSIGNED_BYTE,
      Float64 => LibGL::DOUBLE,
      Float32 => LibGL::FLOAT
    }

    def initialize(target, usage)
      @target = TARGETS[target]
      @usage = USAGES[usage]
      LibGL.genBuffers(1, out buffer)
      @buffer = buffer
      @data = [] of T
      @data_type = TYPES[T]
    end

    def data=(data : Array(T))
      @data = data
      bind do
        LibGL.bufferData(@target, data.size * sizeof(T), data, @usage)
      end
    end

    def bind
      bind!
      yield
    end

    def bind!
      LibGL.bindBuffer(@target, @buffer)
    end

    def to_unsafe
      @buffer
    end

    def delete
      LibGL.deleteBuffers(1, pointerof(@buffer))
    end

    def finalize
      delete
    end
  end
end
