require "../src/opengl.cr"
require "glfw"

hints = {
  LibGLFW3::OPENGL_PROFILE => LibGLFW3::OPENGL_CORE_PROFILE,
  LibGLFW3::OPENGL_FORWARD_COMPAT => 1,
  LibGLFW3::CONTEXT_VERSION_MAJOR => 3,
  LibGLFW3::CONTEXT_VERSION_MINOR => 3
}

window = GLFW::Window.new(800, 600, "Hello, Crystal!")

window.make_current

GLFW.swap_interval = 1

vao = OpenGL::VertexArray.new

vao.bind do
  vertices = OpenGL::Buffer(Float32).new(:array, :static_draw)
  vertices.data = [
    -0.6f32, -0.4f32, 0.0f32,
     0.6f32, -0.4f32, 0.0f32,
     0.0f32,  0.6f32, 0.0f32
  ]

  colors = OpenGL::Buffer(Float32).new(:array, :static_draw)
  colors.data = [
    1.0f32, 0.0f32, 0.0f32,
    0.0f32, 1.0f32, 0.0f32,
    0.0f32, 0.0f32, 1.0f32
  ]

  indices = OpenGL::Buffer(Int32).new(:element_array, :static_draw)
  indices.data = [0i32, 1i32, 2i32]
end

until window.should_close?
  fb_size = window.framebuffer_size
  ratio = fb_size[:width].to_f / fb_size[:height].to_f

  LibGL.viewport(0, 0, fb_size[:width], fb_size[:height])
  LibGL.clear(LibGL::COLOR_BUFFER_BIT)

  # TODO: maths
  # TODO: shaders

  vao.draw

  window.swap_buffers
  GLFW.poll_for_events
end
