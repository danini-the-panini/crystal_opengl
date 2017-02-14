require "../minitest_helper"

class TestColor < Minitest::Test

  def test_constructor
    c = OpenGL::Color.new
    assert(c.r > 0)
    assert(c.g > 0)
    assert(c.b > 0)
  end

  def test_rgb_constructor
    c = OpenGL::Color.new(1, 1, 1)
    assert_in_delta(1, c.r)
    assert_in_delta(1, c.g)
    assert_in_delta(1, c.b)
  end

  def test_copy_hex
    c = OpenGL::Color.new
    c2 = OpenGL::Color.new(0xF5FFFA)
    c.copy(c2)
    assert_in_delta(c2.hex, c.hex)
  end

  def test_copy_color_string
    c = OpenGL::Color.new
    c2 = OpenGL::Color.new("ivory")
    c.copy(c2)
    assert_in_delta(c2.hex, c.hex)
  end

  def test_set_rgb
    c = OpenGL::Color.new
    c.set_rgb(1, 0.2, 0.1)
    assert_in_delta(1, c.r)
    assert_in_delta(0.2, c.g)
    assert_in_delta(0.1, c.b)
  end

  def test_copy_gamma_to_linear
    c = OpenGL::Color.new
    c2 = OpenGL::Color.new
    c2.set_rgb(0.3, 0.5, 0.9)
    c.copy_gamma_to_linear(c2)
    assert_in_delta(0.09f32,  c.r)
    assert_in_delta(0.25f32,  c.g)
    assert_in_delta(0.81f32,  c.b)
  end

  def test_copy_linear_to_gamma
    c = OpenGL::Color.new
    c2 = OpenGL::Color.new
    c2.set_rgb(0.09, 0.25, 0.81)
    c.copy_linear_to_gamma(c2)
    assert_in_delta(0.3,  c.r)
    assert_in_delta(0.5,  c.g)
    assert_in_delta(0.9,  c.b)
  end


  def test_convert_gamma_to_linear
    c = OpenGL::Color.new
    c.set_rgb(0.3, 0.5, 0.9)
    c.convert_gamma_to_linear
    assert_in_delta(0.09, c.r)
    assert_in_delta(0.25, c.g)
    assert_in_delta(0.81, c.b)
  end


  def test_convert_linear_to_gamma
    c = OpenGL::Color.new
    c.set_rgb(4, 9, 16)
    c.convert_linear_to_gamma
    assert_in_delta(2, c.r)
    assert_in_delta(3, c.g)
    assert_in_delta(4, c.b)
  end

  def test_set_with_num
    c = OpenGL::Color.new
    c.set(0xFF0000)
    assert_in_delta(1, c.r)
    assert_in_delta(0, c.g)
    assert_in_delta(0, c.b)
  end


  def test_set_with_string
    c = OpenGL::Color.new
    c.set("silver")
    assert_in_delta(0xC0C0C0, c.hex)
  end

  def test_clone
    c = OpenGL::Color.new("teal")
    c2 = c.clone
    assert_in_delta(0x008080, c2.hex)
  end

  def test_lerp
    c = OpenGL::Color.new
    c2 = OpenGL::Color.new
    c.set_rgb(0, 0, 0)
    c.lerp(c2, 0.2)
    assert_in_delta(0.2, c.r)
    assert_in_delta(0.2, c.g)
    assert_in_delta(0.2, c.b)
  end

  def test_set_style_rgb_red
    c = OpenGL::Color.new
    c.set_style("rgb(255,0,0)")
    assert_in_delta(1, c.r)
    assert_in_delta(0, c.g)
    assert_in_delta(0, c.b)
  end

  def test_set_style_rgb_red_with_spaces
    c = OpenGL::Color.new
    c.set_style("rgb(255, 0, 0)")
    assert_in_delta(1, c.r)
    assert_in_delta(0, c.g)
    assert_in_delta(0, c.b)
  end

  def test_set_style_rgb_percent
    c = OpenGL::Color.new
    c.set_style("rgb(100%,50%,10%)")
    assert_in_delta(1, c.r)
    assert_in_delta(0.5, c.g)
    assert_in_delta(0.1, c.b)
  end

  def test_set_style_rgb_percent_with_spaces
    c = OpenGL::Color.new
    c.set_style("rgb(100%,50%,10%)")
    assert_in_delta(1, c.r)
    assert_in_delta(0.5, c.g)
    assert_in_delta(0.1, c.b)
  end

  def test_set_style_hex_sky_blue
    c = OpenGL::Color.new
    c.set_style("#87CEEB")
    assert_in_delta(0x87CEEB, c.hex)
  end

  def test_set_style_hex_2O_live
    c = OpenGL::Color.new
    c.set_style("#F00")
    assert_in_delta(0xFF0000, c.hex)
  end

  def test_set_style_color_name
    c = OpenGL::Color.new
    c.set_style("powderblue")
    assert_in_delta(0xB0E0E6, c.hex)
  end

  def test_get_hex
    c = OpenGL::Color.new("red")
    res = c.hex
    assert_in_delta(0xFF0000, res)
  end

  def test_set_hex
    c = OpenGL::Color.new
    c.set_hex(0xFA8072)
    assert_in_delta(0xFA8072,  c.hex)
  end

  def test_get_hex_string
    c = OpenGL::Color.new("tomato")
    res = c.hex_string
    assert_equal("ff6347", res)
  end

  def test_get_style
    c = OpenGL::Color.new("plum")
    res = c.style
    assert_equal("rgb(221,160,221)", res)
  end

  def test_get_hsl
    c = OpenGL::Color.new(0x80ffff)
    hsl = c.hsl

    assert_in_delta(0.5, hsl[:h])
    assert_in_delta(1.0, hsl[:s])
    assert_in_delta(0.75, ((hsl[:l].to_f32*100.0).round/100.0))
  end

  def test_set_hsl
    c = OpenGL::Color.new
    c.set_hsl(0.75, 1.0, 0.25)
    hsl = c.hsl

    assert_in_delta(0.75, hsl[:h])
    assert_in_delta(1.00, hsl[:s])
    assert_in_delta(0.25, hsl[:l])
  end
end
