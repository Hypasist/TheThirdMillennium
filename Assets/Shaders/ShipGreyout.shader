shader_type canvas_item;
uniform bool greyout;

const float greyForce = 4.0;
const float transparentForce = 0.8;

void vertex() {
  // Animate Sprite moving in big circle around its location
  // VERTEX += vec2(cos(TIME)*100.0, sin(TIME)*100.0);
  // VERTEX += UV;
}

void fragment() {
    COLOR = texture(TEXTURE, UV);
    if(greyout) {
        float g = (COLOR.r + COLOR.g + COLOR.b)/greyForce;
        COLOR = vec4(g, g, g, COLOR.a * transparentForce); // sin(TIME);
    }
    // COLOR = vec4(sin(TIME), UV, 1.0);
}

//void light() {
//    LIGHT_VEC = vec2(20.0, 30.0);
//    LIGHT_COLOR = vec4(0.5, 1.0, 0.0, 1.0);
//    LIGHT = vec4(0.0, 1.0, 0.0, 1.0);
//}

//void fragment() {
//  ALBEDO = vec3(1.0, 0, 0);   
//}