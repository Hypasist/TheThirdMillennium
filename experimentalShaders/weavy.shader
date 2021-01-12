shader_type canvas_item;

uniform vec2 tiled_factor = vec2(5, 5);
uniform float aspect_ratio = 0.50;

void vertex()
{
    //VERTEX.x = VERTEX.x + cos(TIME * 2.0) * 20.0;
    //VERTEX.y = VERTEX.y + sin(TIME) * 20.0;
   }

void fragment()
{
    vec2 tiled_uvs = UV * tiled_factor;
    tiled_uvs.y *= aspect_ratio;
    
    vec2 waves_uv_offset;
    waves_uv_offset.x = 0.2 * cos(TIME) + sin(tiled_uvs.y * 3.0 + TIME) * 0.33;//sin(tiled_uvs.y * 10.0)*0.05;// + tiled_uvs.x + tiled_uvs.y) * 0.05;
    waves_uv_offset.y = sin(TIME) * 0.05;
    
    
    //COLOR = vec4(0.0, tiled_uvs, 1.0);
    COLOR = texture(TEXTURE, tiled_uvs + waves_uv_offset);
   }