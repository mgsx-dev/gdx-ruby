#ifdef GL_ES
#define LOWP lowp
precision mediump float;
#else
#define LOWP
#endif

varying vec2 v_texCoords;

void main() {
    float f = sin(v_texCoords.x) * 0.5 + 0.5;
    gl_FragColor = vec4(f, f, f, 1.0);
}
