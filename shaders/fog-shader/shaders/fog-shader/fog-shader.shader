// Shaders by BrainzPlayz
// Please give credit if you are to use these in your projects. It is not necessary but is very well appreciated!
shader_type canvas_item;

// change the values of the color to match it to your scene background
uniform vec3 color = vec3(0.96, 0.62, 0.32);

uniform int OCTAVES = 4;

float rand(vec2 coordinates){
	return fract(sin(dot(coordinates, vec2(56, 78)) * 1000.0) * 1000.0);
}

float noise(vec2 coordinates){
	vec2 i = floor(coordinates);
	vec2 fractional_noise = fract(coordinates);
	
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 cubic = fractional_noise * fractional_noise * (3.0 - 2.0 * fractional_noise);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float fractal_brownian_motion(vec2 coordinates){
	float value = 0.0;
	float scale = 0.5;

	for(int i = 0; i < OCTAVES; i++){
		value += noise(coordinates) * scale;
		coordinates *= 2.0;
		scale *= 0.5;
	}
	return value;
}

void fragment(){
	vec2 coordinates = UV * 20.0;
	vec2 motion = vec2(fractal_brownian_motion(coordinates+vec2(TIME * -0.5, TIME * 0.5)));
	float final = fractal_brownian_motion(coordinates + motion);
	COLOR = vec4(color, final * 0.5);
}