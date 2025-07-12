shader_type canvas_item;

uniform float blur_radius = 1.0;

void fragment() {
    vec2 pixel_size = 1.0 / TEXTURE_PIXEL_SIZE;
    vec4 color_sum = vec4(0.0);
    int sample_count = 0;

    for (float x = -blur_radius; x <= blur_radius; x++) {
        for (float y = -blur_radius; y <= blur_radius; y++) {
            vec2 offset = vec2(x, y) / pixel_size;
            color_sum += texture(TEXTURE, UV + offset);
            sample_count++;
        }
    }
    COLOR = color_sum / float(sample_count);
}