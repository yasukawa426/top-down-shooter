shader_type canvas_item;
// Vector 4 for color with deafult color white
uniform vec4 blink_color: source_color;
uniform float blink_intensity = 0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	// mix the texture with the chosen color - 
	color = mix(color, blink_color, blink_intensity * color.a);
	
	COLOR = color;
}