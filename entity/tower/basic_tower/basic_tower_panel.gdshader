shader_type canvas_item;

uniform float y_ratio:hint_range(0.0, 1.0 , 0.01);

void fragment() {
	float y_r = (1.17 -.51)*y_ratio+.51;
	if(VERTEX.y<y_r*800.0)
	{
		COLOR.a=0.0;
	}
}
