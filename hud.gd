extends CanvasLayer

@onready var barra_vida = $barra_vida
@onready var barra_xp = $barra_xp
@onready var texto_tesouros = $texto_tesouros

func atualiza_vida(novas_vidas: int):
	if barra_vida:
		barra_vida.value = novas_vidas

func atualiza_xp(novo_xp: int):
	if barra_xp:
		barra_xp.value = novo_xp

func atualiza_tesouros(num_tesouros: int):
	if texto_tesouros:
		texto_tesouros.text = "Tesouros: " + str(num_tesouros) + "/6"
