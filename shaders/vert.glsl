attribute vec4 a_position;
uniform mat4 u_projModelView; // XXX u_projTrans;
varying vec2 v_texCoords;

void main()
{
	v_texCoords = a_position.xy;
	gl_Position =  u_projModelView * a_position;
}