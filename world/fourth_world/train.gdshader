shader_type canvas_item;

void vertex() {
	float i = 1000.0;
	VERTEX.x -= tan(TIME)*i;
	VERTEX.y += tan(TIME)*i/1.9;
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
