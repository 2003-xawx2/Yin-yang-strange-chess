shader_type canvas_item;

uniform float swing_a = 20;
uniform float swing_multipler = .5;

void vertex() {
	float time = sin(swing_multipler*TIME);
	if (VERTEX.y<0.0)
		VERTEX.x+=time*swing_a;
	
}
