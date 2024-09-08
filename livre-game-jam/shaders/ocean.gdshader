shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D tex_vtx_4 = vec4(0, 44, 125, 255);
uniform sampler2D tex_frg_3;
uniform sampler2D tex_frg_9;



void vertex() {
// Input:2
	float n_out2p0 = TIME;


// UVFunc:3
	vec2 n_in3p1 = vec2(0.10000, 0.10000);
	vec2 n_out3p0 = vec2(n_out2p0) * n_in3p1 + UV;


// Texture2D:4
	vec4 n_out4p0 = texture(tex_vtx_4, n_out3p0);


// Input:5
	vec3 n_out5p0 = NORMAL;


// FloatConstant:9
	float n_out9p0 = 5.000000;


// VectorOp:8
	vec3 n_out8p0 = n_out5p0 * vec3(n_out9p0);


// Input:6
	vec3 n_out6p0 = VERTEX;


// MultiplyAdd:7
	vec4 n_out7p0 = fma(n_out4p0, vec4(n_out8p0, 0.0), vec4(n_out6p0, 0.0));


// Output:0
	VERTEX = vec3(n_out7p0.xyz);


}

void fragment() {
// ColorConstant:14
	vec4 n_out14p0 = vec4(0.000001, 0.172964, 0.491105, 1.000000);


// Input:6
	float n_out6p0 = TIME;


// UVFunc:5
	vec2 n_in5p1 = vec2(0.10000, 0.10000);
	vec2 n_out5p0 = vec2(n_out6p0) * n_in5p1 + UV;


// Texture2D:3
	vec4 n_out3p0 = texture(tex_frg_3, n_out5p0);


// Input:7
	float n_out7p0 = TIME;


// UVFunc:8
	vec2 n_in8p1 = vec2(-0.10000, -0.10000);
	vec2 n_out8p0 = vec2(n_out7p0) * n_in8p1 + UV;


// Texture2D:9
	vec4 n_out9p0 = texture(tex_frg_9, n_out8p0);


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
