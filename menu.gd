extends Control

func _on_btn_jogar_pressed():
	get_tree().change_scene_to_file("res://Men.tscn")

func _on_btn_sair_pressed():
	get_tree().quit()
