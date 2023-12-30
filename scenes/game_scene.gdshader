shader_type canvas_item;

uniform vec2 scroll_speed = vec2(1.0, 1.0);
uniform vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {
    
}

void fragment() {
    vec2 moving_uv = vec2(UV.x - (TIME * scroll_speed.x), UV.y - (TIME * scroll_speed.y));
    vec4 in_tex = texture(TEXTURE, moving_uv);
    COLOR = in_tex * color;
}

void light() {

}