shader_type canvas_item;
uniform float size=0;
uniform float uv_x = .5;
uniform float uv_y = .5;

void fragment() {
	float dis = pow(pow(UV.x-uv_x,2)+pow(UV.y-uv_y,2),0.5);
	COLOR.a = dis*2.+size;
}