shader_type canvas_item;

uniform float Xstrength = 0.02;
uniform float Xstrips = 6;

uniform float Ystrength = 0.02;
uniform float Ystrips = 6;

void fragment() {
	vec2 uv = UV;
	uv.x += (UV.y + (floor(UV.y * Xstrips))) * Xstrength;
	uv.y += (UV.x + (floor(UV.x * Ystrips))) * Ystrength;
	COLOR = texture(TEXTURE, uv);
}