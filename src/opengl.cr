require "lib_gl"

require "./opengl/*"
require "./opengl/math/*"

module OpenGL
  def self.check_error
    error_code = LibGL.getError()
    case error_code
    when LibGL::NO_ERROR
      # no error
    when LibGL::INVALID_ENUM
      raise OpenGLException.new("INVALID_ENUM: Given when an enumeration parameter is not a legal enumeration for that function. This is given only for local problems; if the spec allows the enumeration in certain circumstances, where other parameters or state dictate those circumstances, then INVALID_OPERATION is the result instead.")
    when LibGL::INVALID_VALUE
      raise OpenGLException.new("INVALID_VALUE: Given when a value parameter is not a legal value for that function. This is only given for local problems; if the spec allows the value in certain circumstances, where other parameters or state dictate those circumstances, then INVALID_OPERATION is the result instead.")
    when LibGL::INVALID_OPERATION
      raise OpenGLException.new("INVALID_OPERATION: Given when the set of state for a command is not legal for the parameters given to that command. It is also given for commands where combinations of parameters define what the legal parameters are.")
    when LibGL::STACK_OVERFLOW
      raise OpenGLException.new("STACK_OVERFLOW: Given when a stack pushing operation cannot be done because it would overflow the limit of that stack's size.")
    when LibGL::STACK_UNDERFLOW
      raise OpenGLException.new("STACK_UNDERFLOW: Given when a stack popping operation cannot be done because the stack is already at its lowest point.")
    when LibGL::OUT_OF_MEMORY
      raise OpenGLException.new("OUT_OF_MEMORY: Given when performing an operation that can allocate memory, and the memory cannot be allocated. The results of OpenGL functions that return this error are undefined; it is allowable for partial operations to happen.")
    when LibGL::INVALID_FRAMEBUFFER_OPERATION
      raise OpenGLException.new("INVALID_FRAMEBUFFER_OPERATION: Given when doing anything that would attempt to read from or write/render to a framebuffer that is not complete.")
    when LibGL::CONTEXT_LOST
      raise OpenGLException.new("CONTEXT_LOST: Given if the OpenGL context has been lost, due to a graphics card reset.")
    else
      raise OpenGLException.new("Unknown Error: #{error_code}")
    end
  end

  class OpenGLException < Exception
  end
end
