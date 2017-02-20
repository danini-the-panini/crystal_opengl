require "../src/opengl.cr"
require "glfw"

require "magickwand-crystal"

hints = {
  LibGLFW3::OPENGL_PROFILE => LibGLFW3::OPENGL_CORE_PROFILE,
  LibGLFW3::OPENGL_FORWARD_COMPAT => 1,
  LibGLFW3::CONTEXT_VERSION_MAJOR => 4,
  LibGLFW3::CONTEXT_VERSION_MINOR => 1
}

window = GLFW::Window.new(800, 600, "Hello, Crystal!", hints)

window.make_current

GLFW.swap_interval = 1

LibGL.enable(LibGL::DEPTH_TEST)
LibGL.depthFunc(LibGL::LESS)

vao = OpenGL::VertexArray.new
vertices = uninitialized OpenGL::Buffer(Float32)
colors = uninitialized OpenGL::Buffer(Float32)
uvs = uninitialized OpenGL::Buffer(Float32)
indices = uninitialized OpenGL::Buffer(UInt32)

vao.bind do
  vertices = OpenGL::Buffer(Float32).new(:array, :static_draw)
  vertices.data = [
    -0.5f32,  0.5f32, 0f32,
    -0.5f32, -0.5f32, 0f32,
     0.5f32, -0.5f32, 0f32,
     0.5f32,  0.5f32, 0f32
  ]

  colors = OpenGL::Buffer(Float32).new(:array, :static_draw)
  colors.data = [
    1.0f32, 0.0f32, 0.0f32,
    0.0f32, 1.0f32, 0.0f32,
    0.0f32, 0.0f32, 1.0f32,
    1.0f32, 0.0f32, 1.0f32
  ]

  uvs = OpenGL::Buffer(Float32).new(:array, :static_draw)
  uvs.data = [
    0f32, 1f32,
    0f32, 0f32,
    1f32, 0f32,
    1f32, 1f32
  ]

  indices = OpenGL::Buffer(UInt32).new(:element_array, :static_draw)
  indices.data = [0u32, 1u32, 2u32, 2u32, 3u32, 0u32]
end

program = OpenGL::Program.new

vertex_shader = OpenGL::Shader.new(:vertex)
vertex_shader.source = "
#version 410
in vec3 vertex_position;
in vec3 vertex_color;
in vec2 vertex_uv;

out vec3 v_color;
out vec2 v_uv;

void main() {
  v_color = vertex_color;
  v_uv = vertex_uv;
  gl_Position = vec4(vertex_position, 1.0);
}
"
begin
  vertex_shader.compile
rescue ex : OpenGL::ShaderCompilationException
  puts ex.log
  puts ex.source
end

fragment_shader = OpenGL::Shader.new(:fragment)
fragment_shader.source = "
#version 410
uniform vec3 input_color;
uniform sampler2D tex;

in vec3 v_color;
in vec2 v_uv;

out vec4 frag_color;

void main() {
  vec3 s = texture(tex, v_uv).rgb;
  frag_color = vec4(input_color.r * v_color.r * s.r,
                    input_color.g * v_color.g * s.g,
                    input_color.b * v_color.b * s.b,
                    1.0);
}
"
begin
  fragment_shader.compile
rescue ex : OpenGL::ShaderCompilationException
  puts ex.log
  puts ex.source
end

program.attach(vertex_shader)
program.attach(fragment_shader)
program.link

program.use

program.set_uniform("input_color", 1.0f32, 0.3f32, 0.5f32)

vao.attribute_pointer(vertices,
                      program.attribute_location("vertex_position"),
                      3)

vao.attribute_pointer(colors,
                      program.attribute_location("vertex_color"),
                      3)

vao.attribute_pointer(uvs,
                      program.attribute_location("vertex_uv"),
                      2)

texture = OpenGL::Texture.new(:texture2D, { texture_wrap_s: :repeat,
                                            texture_wrap_t: :repeat,
                                            texture_mag_filter: :linear,
                                            texture_min_filter: :linear })

LibMagick.magickWandGenesis
wand = LibMagick.newMagickWand
if LibMagick.magickReadImage wand, "samples/texture.png"
  width = LibMagick.magickGetImageWidth wand
  height = LibMagick.magickGetImageHeight wand
  pixels = Slice(UInt8).new(width * height * 3)
  if LibMagick.magickExportImagePixels wand, 0, 0, width, height, "RGB", LibMagick::StorageType::CharPixel, pixels
    texture.set_data(width, height, pixels, LibGL::RGB, LibGL::RGB, LibGL::UNSIGNED_BYTE)
  else
    raise "Can't export image data"
  end
else
  raise "Can't read image file"
end
LibMagick.destroyMagickWand wand
LibMagick.magickWandTerminus

program.set_uniform("tex", 0u32)

until window.should_close?
  fb_size = window.framebuffer_size
  ratio = fb_size[:width].to_f / fb_size[:height].to_f

  LibGL.viewport(0, 0, fb_size[:width], fb_size[:height])
  LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)

  program.use
  vao.bind do
    vao.draw_elements(indices, :triangles)
  end

  window.swap_buffers
  GLFW.poll_for_events
end
