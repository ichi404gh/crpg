shader_type canvas_item;

instance uniform bool flash = false;
instance uniform bool outline = false;
uniform vec4 outline_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_thicness: hint_range(1.0, 5.0) = 1.0;

float is_positive(float value) {
	return max(0.0, sign(value));
}

float has_solid_neighbor(sampler2D texture_sampler, vec2 uv_coord, vec2 pixel_size) {
	vec2 offset = outline_thicness * pixel_size;
	float sum_alpha = 0.0;
	sum_alpha += texture(texture_sampler, uv_coord + vec2(1.0, 0.0) * offset).a;
	sum_alpha += texture(texture_sampler, uv_coord + vec2(-1.0, 0.0) * offset).a;
	sum_alpha += texture(texture_sampler, uv_coord + vec2(0.0, 1.0) * offset).a;
	sum_alpha += texture(texture_sampler, uv_coord + vec2(0.0, -1.0) * offset).a;
	return is_positive(sum_alpha);
}

void fragment() {

	vec4 previous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
	vec4 new_color = previous_color;

	// flash
	if (flash == true)
	{
		new_color = white_color;
	}
	COLOR = new_color;

	// outline
	if (outline && COLOR.a == 0.0) {
		float outline_mask = has_solid_neighbor(TEXTURE, UV, TEXTURE_PIXEL_SIZE);
		if (outline_mask > 0.0) {
			COLOR = outline_color;
		}
	}
}