shader_type canvas_item;

//hint color para poder seleccionar el color del flash en el editor
uniform vec4 flashColor : hint_color = vec4(1.0);
uniform float flashRange : hint_range(0.0,1.0) = 0.0;

void fragment(){
	float timer = 0.0;
	//obtengo los colores de cada pixel de la imagen
	vec4 color = texture(TEXTURE, UV);
	//mixea el color de flash por el porcentaje de range con los colores originales de la imagen
	color.rgb = mix(color.rgb, flashColor.rgb, flashRange);
	//asigno los nuevos colores a la imagen
	COLOR = color;
}