shader_type canvas_item;

uniform float fade_radius = 0.8;
uniform vec2 center = vec2(0.5, 0.5);
uniform float smoothness = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float dist = distance(UV, center);
    float alpha = smoothstep(smoothness, fade_radius, dist);
    alpha *= smoothstep(smoothness, fade_radius, dist);
    tex_color.a *= (alpha);
    COLOR = tex_color;
}