// Godot Shader Language (GLSL-like)
shader_type canvas_item; // Essential for 2D nodes

// Uniforms: Exposed parameters you can change in the Inspector
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Black outline by default
uniform float outline_width : hint_range(0.0, 10.0) = 1.0; // Outline width in pixels
uniform bool use_screen_uv = false; // Use screen coordinates (usually false for sprite outlines)

void fragment() {
    vec2 uv = use_screen_uv ? SCREEN_UV : UV;
    vec2 pixel_size = use_screen_uv ? SCREEN_PIXEL_SIZE : TEXTURE_PIXEL_SIZE;
    
    float current_alpha = texture(TEXTURE, uv).a;
    float max_neighbor_alpha = 0.0;

    // Sample neighbors (you can add diagonals for a smoother look)
    // Increase loop range or add more explicit samples for thicker outlines
    // Note: This samples 4 direct neighbors.
    vec2 offsets[4] = vec2[](
        vec2(-outline_width, 0.0),
        vec2(outline_width, 0.0),
        vec2(0.0, -outline_width),
        vec2(0.0, outline_width)
    );

    for (int i = 0; i < 4; i++) {
        vec2 neighbor_uv = uv + offsets[i] * pixel_size;
        max_neighbor_alpha = max(max_neighbor_alpha, texture(TEXTURE, neighbor_uv).a);
    }

    // If current pixel is transparent (or semi-transparent below a threshold)
    // AND any neighbor is opaque enough, draw the outline color.
    // The 0.1 threshold prevents faint outlines around anti-aliased edges inside the sprite.
    if (current_alpha < 0.1 && max_neighbor_alpha > 0.5) {
        COLOR = outline_color;
    } else {
        // Otherwise, draw the original pixel color
        COLOR = texture(TEXTURE, uv);
        // Optional: If you want the outline *inside* the opaque area instead of outside:
        // float min_neighbor_alpha = 1.0;
        // for (int i = 0; i < 4; i++) { ... min_neighbor_alpha = min(...) }
        // if (current_alpha > 0.5 && min_neighbor_alpha < 0.1) { COLOR = outline_color; } else { COLOR = texture(TEXTURE, uv); }
    }
}