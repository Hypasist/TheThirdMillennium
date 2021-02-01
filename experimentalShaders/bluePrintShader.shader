shader_type canvas_item;

uniform vec2 tiled_factor = vec2(5, 5);
uniform float aspect_ratio = 1;

void fragment()
{
    vec2 tiled_uvs = UV * tiled_factor;
    tiled_uvs.y *= aspect_ratio;
    COLOR = texture(TEXTURE, tiled_uvs);
}