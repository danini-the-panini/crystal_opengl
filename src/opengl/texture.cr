require "lib_gl"

module OpenGL
  class Texture
    TARGETS = {
      texture1D:                   LibGL::TEXTURE_1D,
      texture2D:                   LibGL::TEXTURE_2D,
      texture3D:                   LibGL::TEXTURE_3D,
      texture1D_array:             LibGL::TEXTURE_1D_ARRAY,
      texture2D_array:             LibGL::TEXTURE_2D_ARRAY,
      texture_rectangle:           LibGL::TEXTURE_RECTANGLE,
      texture_cube_map:            LibGL::TEXTURE_CUBE_MAP,
      texture_cube_map_array:      LibGL::TEXTURE_CUBE_MAP_ARRAY,
      texture_buffer:              LibGL::TEXTURE_BUFFER,
      texture2D_multisample:       LibGL::TEXTURE_2D_MULTISAMPLE,
      texture2D_multisample_array: LibGL::TEXTURE_2D_MULTISAMPLE_ARRAY
    }

    DATA_TYPES = {
      UInt8   => LibGL::UNSIGNED_BYTE,
      Int8    => LibGL::BYTE,
      Uint16  => LibGL::UNSIGNED_SHORT,
      Int16   => LibGL::SHORT,
      UInt32  => LibGL::UNSIGNED_INT,
      Int32   => LibGL::INT,
      Float32 => LibGL::FLOAT
    }

    PARAM_KEYS = {
      texture_min_filter:   LibGL::TEXTURE_MIN_FILTER,
      texture_mag_filter:   LibGL::TEXTURE_MAG_FILTER,
      texture_min_lod:      LibGL::TEXTURE_MIN_LOD,
      texture_max_lod:      LibGL::TEXTURE_MAX_LOD,
      texture_base_level:   LibGL::TEXTURE_BASE_LEVEL,
      texture_max_level:    LibGL::TEXTURE_MAX_LEVEL,
      texture_wrap_s:       LibGL::TEXTURE_WRAP_S,
      texture_wrap_t:       LibGL::TEXTURE_WRAP_T,
      texture_wrap_r:       LibGL::TEXTURE_WRAP_R,
      texture_border_color: LibGL::TEXTURE_BORDER_COLOR,
      texture_priority:     LibGL::TEXTURE_PRIORITY,
      texture_compare_mode: LibGL::TEXTURE_COMPARE_MODE,
      texture_compare_func: LibGL::TEXTURE_COMPARE_FUNC,
      depth_texture_mode:   LibGL::DEPTH_TEXTURE_MODE,
      generate_mipmap:      LibGL::GENERATE_MIPMAP
    }

    WRAP_VALUES = {
      clamp:           LibGL::CLAMP,
      clamp_to_border: LibGL::CLAMP_TO_BORDER,
      clamp_to_edge:   LibGL::CLAMP_TO_EDGE,
      mirrored_repeat: LibGL::MIRRORED_REPEAT,
      repeat:          LibGL::REPEAT
    }

    PARAM_VALUES = {
      texture_min_filter: {
        nearest:                LibGL::NEAREST,
        linear:                 LibGL::LINEAR,
        nearest_mipmap_nearest: LibGL::NEAREST_MIPMAP_NEAREST,
        linear_mipmap_nearest:  LibGL::LINEAR_MIPMAP_NEAREST,
        nearest_mipmap_linear:  LibGL::NEAREST_MIPMAP_LINEAR,
        linear_mipmap_linear:   LibGL::LINEAR_MIPMAP_LINEAR
      },
      texture_mag_filter: {
        nearest: LibGL::NEAREST,
        linear:  LibGL::LINEAR
      },
      texture_wrap_s: WRAP_VALUES,
      texture_wrap_t: WRAP_VALUES,
      texture_wrap_r: WRAP_VALUES,
      texture_compare_mode: {
        compare_r_to_texture: LibGL::COMPARE_R_TO_TEXTURE,
        none:                 LibGL::NONE
      },
      texture_compare_func: {
        lequal:   LibGL::LEQUAL,
        gequal:   LibGL::GEQUAL,
        less:     LibGL::LESS,
        greater:  LibGL::GREATER,
        equal:    LibGL::EQUAL,
        notequal: LibGL::NOTEQUAL,
        always:   LibGL::ALWAYS,
        never:    LibGL::NEVER
      },
      depth_texture_mode: {
        luminance: LibGL::LUMINANCE,
        intensity: LibGL::INTENSITY,
        alpha:     LibGL::ALPHA
      }
    }

    alias ParamValueType = (LibGL::Float | LibGL::Int | Array(LibGL::Float) | Array(LibGL::Int) | Bool | Symbol)

    @tex    : LibGL::UInt
    @target : LibGL::UInt

    def initialize(target, params = {} of Symbol => ParamValueType)
      LibGL.genTextures(1, out tex)
      @tex = tex
      @target = TARGETS[target]
      set_params params
    end

    def bind!
      LibGL.bindTexture(@target, @tex)
    end

    def bind
      bind!
      yield
    end

    def bind_to_slot!(index)
      Texture.active_slot = index
      bind!
    end

    def bind_to_slot(index)
      bind_to_slot!
      yield
    end

    def self.active_slot=(index)
      LibGL.activeTexture(LibGL::TEXTURE0 + index)
    end

    def set_data(width, height, data, internal_format, format)
      type = typeof(data[0])
      set_data(width, height, data, internal_format, format, DATA_TYPES[type])
    end

    def set_data(width, height, data, internal_format, format, type)
      LibGL.texImage2D(@target, 0, internal_format, width, height, 0, format, type, data)
    end

    def set_param(key : Symbol, value : ParamValueType)
      if value.is_a?(LibGL::Float)
        LibGL.texParameterf(@target, PARAM_KEYS[key], value)
      elsif value.is_a?(LibGL::Int)
        LibGL.texParameteri(@target, PARAM_KEYS[key], value)
      elsif value.is_a?(Array(LibGL::Float))
        LibGL.texParameterfv(@target, PARAM_KEYS[key], value)
      elsif value.is_a?(Array(LibGL::Int))
        LibGL.texParameteriv(@target, PARAM_KEYS[key], value)
      elsif value.is_a?(Bool)
        LibGL.texParameteri(@target, PARAM_KEYS[key], value ? LibGL::TRUE : LibGL::FALSE)
      elsif value.is_a?(Symbol)
        LibGL.texParameteri(@target, PARAM_KEYS[key], PARAM_VALUES[key][value])
      end
    end

    def set_params(params = {} of LibGL::Enum => ParamValueType)
      bind do
        params.each do |key, value|
          set_param(key, value)
        end
      end
    end
  end
end
