shader_type canvas_item;

uniform float scroll_speed = 1.0;
uniform vec4 color = vec4(1.0, 1.0, 1.0, 1.0); // Default is white

void vertex() {
    
}

void fragment() {
    vec2 moving_uv = vec2(UV.x - (TIME * scroll_speed), UV.y);
    vec4 in_tex = texture(TEXTURE, moving_uv);
    COLOR = in_tex * color;
}

void light() {

}