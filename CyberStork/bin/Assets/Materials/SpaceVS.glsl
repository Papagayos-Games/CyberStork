#version 330 core

in vec4 vertex; 				// atributos de los vértices a procesar
in vec2 uv0; 					// coordenadas de textura 0

uniform float SinTiempo;		//Tiempo de la animacion
uniform float ZF;
uniform mat4 modelViewProjMat; 	// constante de programa

out vec2 vUv0;	 				// out del vertex shader T0
out vec2 vUv1;					// out del vertex shader T1

void main(){
	vec2 text0 = uv0;
	
	//Zoom fijo
	//vec2 text1 = (text0 - 0.5) * ZF + 0.5;
	
	//Zoom animado
	float aux = SinTiempo * 0.25 + 0.75;
	vec2 text1;
	text1.s = (text0.s - 0.5) * aux + 0.5;
	text1.t = (text0.t - 0.5) * aux + 0.5;
	
	vUv0 = text0; 								// se pasan las coordenadas de textura
	vUv1 = text1;
	gl_Position = modelViewProjMat * vertex; 	//obligatorio
}