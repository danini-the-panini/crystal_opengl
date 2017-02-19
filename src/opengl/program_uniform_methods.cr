require "lib_gl"

require "./math/vector2"
require "./math/vector3"
require "./math/vector4"
require "./math/euler"
require "./math/quaternion"

require "./math/matrix3"
require "./math/matrix4"

module OpenGL
  module ProgramUniformMethods
    def set_uniform(name : String, v0 : LibGL::Float)
      location = uniform_location(name)
      LibGL.uniform1f(location, v0)
    end

    def set_uniform(name : String, v0 : LibGL::Float, v1 : LibGL::Float)
      location = uniform_location(name)
      LibGL.uniform2f(location, v0, v1)
    end

    def set_uniform(name : String, v0 : LibGL::Float, v1 : LibGL::Float, v2 : LibGL::Float)
      location = uniform_location(name)
      LibGL.uniform3f(location, v0, v1, v2)
    end

    def set_uniform(name : String, v0 : LibGL::Float, v1 : LibGL::Float, v2 : LibGL::Float, v3 : LibGL::Float)
      location = uniform_location(name)
      LibGL.uniform4f(location, v0, v1, v2, v3)
    end

    def set_uniform(name : String, v0 : LibGL::Int)
      location = uniform_location(name)
      LibGL.uniform1i(location, v0)
    end

    def set_uniform(name : String, v0 : LibGL::Int, v1 : LibGL::Int)
      location = uniform_location(name)
      LibGL.uniform2i(location, v0, v1)
    end

    def set_uniform(name : String, v0 : LibGL::Int, v1 : LibGL::Int, v2 : LibGL::Int)
      location = uniform_location(name)
      LibGL.uniform3i(location, v0, v1, v2)
    end

    def set_uniform(name : String, v0 : LibGL::Int, v1 : LibGL::Int, v2 : LibGL::Int, v3 : LibGL::Int)
      location = uniform_location(name)
      LibGL.uniform4i(location, v0, v1, v2, v3)
    end

    def set_uniform(name : String, v0 : LibGL::UInt)
      location = uniform_location(name)
      LibGL.uniform1ui(location, v0)
    end

    def set_uniform(name : String, v0 : LibGL::UInt, v1 : LibGL::UInt)
      location = uniform_location(name)
      LibGL.uniform2ui(location, v0, v1)
    end

    def set_uniform(name : String, v0 : LibGL::UInt, v1 : LibGL::UInt, v2 : LibGL::UInt)
      location = uniform_location(name)
      LibGL.uniform3ui(location, v0, v1, v2)
    end

    def set_uniform(name : String, v0 : LibGL::UInt, v1 : LibGL::UInt, v2 : LibGL::UInt, v3 : LibGL::UInt)
      location = uniform_location(name)
      LibGL.uniform4ui(location, v0, v1, v2, v3)
    end

    def set_uniform(name : String, value : Array(LibGL::Float))
      location = uniform_location(name)
      LibGL.uniform1fv(location, value.size, value)
    end

    def set_uniform2v(name : String, value : Array(LibGL::Float))
      location = uniform_location(name)
      LibGL.uniform2fv(location, value.size/2, value)
    end

    def set_uniform3v(name : String, value : Array(LibGL::Float))
      location = uniform_location(name)
      LibGL.uniform3fv(location, value.size/3, value)
    end

    def set_uniform4v(name : String, value : Array(LibGL::Float))
      location = uniform_location(name)
      LibGL.uniform4fv(location, value.size/4, value)
    end

    def set_uniform(name : String, value : Array(Vector2) | Array(Tuple(LibGL::Float, LibGL::Float)))
      location = uniform_location(name)
      LibGL.uniform2fv(location, value.size, value.map(&.to_a).flatten) # FIXME: this looks really slow!
    end

    def set_uniform(name : String, value : Array(Vector3) | Array(Euler) | Array(Tuple(LibGL::Float, LibGL::Float, LibGL::Float)))
      location = uniform_location(name)
      LibGL.uniform3fv(location, value.size, value.map(&.to_a).flatten) # FIXME: this looks really slow!
    end

    def set_uniform(name : String, value : Array(Vector4) | Array(Quaternion) | Array(Tuple(LibGL::Float, LibGL::Float, LibGL::Float, LibGL::Float)))
      location = uniform_location(name)
      LibGL.uniform4fv(location, value.size, value.map(&.to_a).flatten) # FIXME: this looks really slow!
    end

    def set_uniform(name : String, value : Array(LibGL::Int))
      location = uniform_location(name)
      LibGL.uniform1iv(location, value.size, value)
    end

    def set_uniform2v(name : String, value : Array(LibGL::Int))
      location = uniform_location(name)
      LibGL.uniform2iv(location, value.size/2, value)
    end

    def set_uniform3v(name : String, value : Array(LibGL::Int))
      location = uniform_location(name)
      LibGL.uniform3iv(location, value.size/3, value)
    end

    def set_uniform4v(name : String, value : Array(LibGL::Int))
      location = uniform_location(name)
      LibGL.uniform4iv(location, value.size/4, value)
    end

    def set_uniform(name : String, value : Array(Tuple(LibGL::Int, LibGL::Int)))
      location = uniform_location(name)
      LibGL.uniform2iv(location, value.size, value.map(&.to_a).flatten)
    end

    def set_uniform(name : String, value : Array(Tuple(LibGL::Int, LibGL::Int, LibGL::Int)))
      location = uniform_location(name)
      LibGL.uniform3iv(location, value.size, value.map(&.to_a).flatten)
    end

    def set_uniform(name : String, value : Array(Tuple(LibGL::Int, LibGL::Int, LibGL::Int, LibGL::Int)))
      location = uniform_location(name)
      LibGL.uniform4iv(location, value.size, value.map(&.to_a).flatten)
    end

    def set_uniform(name : String, value : Array(LibGL::UInt))
      location = uniform_location(name)
      LibGL.uniform1uiv(location, value.size, value)
    end

    def set_uniform2v(name : String, value : Array(LibGL::UInt))
      location = uniform_location(name)
      LibGL.uniform2uiv(location, value.size/2, value)
    end

    def set_uniform3v(name : String, value : Array(LibGL::UInt))
      location = uniform_location(name)
      LibGL.uniform3uiv(location, value.size/3, value)
    end

    def set_uniform4v(name : String, value : Array(LibGL::UInt))
      location = uniform_location(name)
      LibGL.uniform4uiv(location, value.size/4, value)
    end

    def set_uniform(name : String, value : Array(Tuple(LibGL::UInt, LibGL::UInt)))
      location = uniform_location(name)
      LibGL.uniform2uiv(location, value.size, value.map(&.to_a).flatten)
    end

    def set_uniform(name : String, value : Array(Tuple(LibGL::UInt, LibGL::UInt, LibGL::UInt)))
      location = uniform_location(name)
      LibGL.uniform3uiv(location, value.size, value.map(&.to_a).flatten)
    end

    def set_uniform(name : String, value : Array(Tuple(LibGL::UInt, LibGL::UInt, LibGL::UInt, LibGL::UInt)))
      location = uniform_location(name)
      LibGL.uniform4uiv(location, value.size, value.map(&.to_a).flatten)
    end

    def set_uniform_matrix2(name : String, value : Array(LibGL::Float), transpose = false)
      location = uniform_location(name)
      LibGL.uniformMatrix2fv(location, value.size/4, transpose, value)
    end

    def set_uniform(name : String, value : Array(Matrix3), transpose = false)
      location = uniform_location(name)
      LibGL.uniformMatrix3fv(location, value.size, transpose, value.map(&.to_a).flatten)
    end

    def set_uniform_matrix3(name : String, value : Array(LibGL::Float), transpose = false)
      location = uniform_location(name)
      LibGL.uniformMatrix3fv(location, value.size/9, transpose, value)
    end

    def set_uniform(name : String, value : Array(Matrix4), transpose = false)
      location = uniform_location(name)
      LibGL.uniformMatrix4fv(location, value.size, transpose, value.map(&.to_a).flatten)
    end

    def set_uniform_matrix4(name : String, value : Array(LibGL::Float), transpose = false)
      location = uniform_location(name)
      LibGL.uniformMatrix4fv(location, value.size/16, transpose, value)
    end

    def set_uniform_matrix2x3(name : String, value : Array(LibGL::Float), transpose = false)
      location = uniform_location(name)
      LibGL.uniformMatrix2x3fv(location, value.size/6, transpose, value)
    end

    def set_uniform_matrix3x2(name : String, value : Array(LibGL::Float), transpose = false)
      location = uniform_location(name)
      LibGL.uniformMatrix3x2fv(location, value.size/6, transpose, value)
    end

    def set_uniform_matrix2x4(name : String, value : Array(LibGL::Float), transpose = false)
      location = uniform_location(name)
      LibGL.uniformMatrix2x4fv(location, value.size/8, transpose, value)
    end

    def set_uniform_matrix4x2(name : String, value : Array(LibGL::Float), transpose = false)
      location = uniform_location(name)
      LibGL.uniformMatrix4x2fv(location, value.size/8, transpose, value)
    end

    def set_uniform_matrix3x4(name : String, value : Array(LibGL::Float), transpose = false)
      location = uniform_location(name)
      LibGL.uniformMatrix3x4fv(location, value.size/12, transpose, value)
    end

    def set_uniform_matrix4x3(name : String, value : Array(LibGL::Float), transpose = false)
      location = uniform_location(name)
      LibGL.uniformMatrix4x3fv(location, value.size/12, transpose, value)
    end
  end
end
