shader_type canvas_item;

uniform float xPlusY = 0;
uniform float yPlusX = 0;

void fragment() {
	vec2 uv = UV;
	uv.x += uv.y * xPlusY;
	uv.y += uv.x * yPlusX;
	COLOR = texture(TEXTURE, uv);
}