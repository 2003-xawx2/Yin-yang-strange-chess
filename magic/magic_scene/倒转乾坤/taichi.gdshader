shader_type canvas_item;

uniform float size_scale = 1;
uniform float time_scale = 1;

void fragment() {
	
	
	COLOR=vec4(0,0,0,0);
	
	vec2 resolution=1.0/SCREEN_PIXEL_SIZE;
	vec2 uv =FRAGCOORD.xy- resolution.xy/2.0;
	
	mat2 rotate=mat2(
		vec2(cos(TIME*time_scale),-sin(TIME*time_scale)),
		vec2(sin(TIME*time_scale),cos(TIME*time_scale))
	);
	uv=rotate*uv;
	
	float min_len=min(resolution.x,resolution.y)/2.0;
	float small_radius=min_len/9.0*size_scale;
	float medium_radius=4.0 * small_radius;
	float radius=2.0*medium_radius;
	
	if(length(uv)<=radius){
		vec3 black=vec3(0);
		vec3 white=vec3(1);
		vec3 output_color=black;
		
		if (uv.x>0.0)
	{
		output_color=black;
	}
	else
	{
		output_color=white;
	}
	
	vec2 down_center=vec2(0.0,medium_radius);
	vec2 up_center=vec2(0.0,-medium_radius);
	if(length(uv-down_center)<medium_radius) output_color=black;
	if(length(uv-up_center)<medium_radius)output_color=white;
	if(length(uv-down_center)<small_radius)output_color=white;
	if(length(uv-up_center)<small_radius)output_color=black;
	COLOR=vec4(output_color,1.0);
	}
		
		//COLOR=vec4(UV,0.0,1.0);
}

