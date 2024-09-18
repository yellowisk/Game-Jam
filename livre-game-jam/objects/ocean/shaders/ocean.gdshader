shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D wave_bump;
uniform sampler2D wave_texture_0;
uniform sampler2D wave_texture_1;
uniform vec2 wave_speed = vec2(0.10000, 0.10000);
uniform float wave_height = 10.00000;
uniform float time = 0.0;

void vertex() {
	vec2 wave_slide_uv = vec2(time) * wave_speed + UV;
	vec4 wave_bump_slide = texture(wave_bump, wave_slide_uv);
	vec3 wave_normal = NORMAL * vec3(wave_height);
	vec3 output = fma(vec3(wave_bump_slide.r), wave_normal, VERTEX);
	VERTEX = output;
}

void fragment() {
// ColorConstant:14
	vec4 n_out14p0 = vec4(0.000001, 0.172964, 0.491105, 1.000000);


// Input:6
	float n_out6p0 = time;


// UVFunc:5
	vec2 n_in5p1 = vec2(0.10000, 0.10000);
	vec2 normal = vec2(n_out6p0) * n_in5p1 + UV;


// Texture2D:3
	vec4 n_out3p0 = texture(wave_texture_0, normal);


// Input:7
	float n_out7p0 = time;


// UVFunc:8
	vec2 n_in8p1 = vec2(-0.10000, -0.10000);
	vec2 n_out8p0 = vec2(n_out7p0) * n_in8p1 + UV;


// Texture2D:9
	vec4 n_out9p0 = texture(wave_texture_1, n_out8p0);


// VectorOp:10
	vec4 n_out10p0 = n_out3p0 * n_out9p0;


// VectorOp:11
	vec4 n_in11p1 = vec4(1.25000, 1.25000, 1.25000, 1.25000);
	vec4 n_out11p0 = pow(n_out10p0, n_in11p1);


// VectorOp:4
	vec3 n_out4p0 = vec3(n_out14p0.xyz) + vec3(n_out11p0.xyz);


// FloatConstant:12
	float n_out12p0 = 0.800000;


// FloatConstant:13
	float n_out13p0 = 0.000000;


// Output:0
	ALBEDO = n_out4p0;
	ALPHA = n_out12p0;
	ROUGHNESS = n_out13p0;
	EMISSION = vec3(n_out11p0.xyz);


}
