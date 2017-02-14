class Minitest::Test
  def x; 2; end
  def y; 3; end
  def z; 4; end
  def w; 5; end

  def negInf2
    @_negInf2 ||= OpenGL::Vector2.new(-Float32::INFINITY, -Float32::INFINITY)
  end
  def posInf2
    @_posInf2 ||= OpenGL::Vector2.new(Float32::INFINITY, Float32::INFINITY)
  end

  def zero2
    @_zero2 ||= OpenGL::Vector2.new
  end
  def one2
    @_one2 ||= OpenGL::Vector2.new(1, 1)
  end
  def two2
    @_two2 ||= OpenGL::Vector2.new(2, 2)
  end

  def negInf3
    @_negInf3 ||= OpenGL::Vector3.new(-Float32::INFINITY, -Float32::INFINITY, -Float32::INFINITY)
  end
  def posInf3
    @_posInf3 ||= OpenGL::Vector3.new(Float32::INFINITY, Float32::INFINITY, Float32::INFINITY)
  end

  def zero3
    @_zero3 ||= OpenGL::Vector3.new()
  end
  def one3
    @_one3 ||= OpenGL::Vector3.new(1, 1, 1)
  end
  def two3
    @_two3 ||= OpenGL::Vector3.new(2, 2, 2)
  end
end
