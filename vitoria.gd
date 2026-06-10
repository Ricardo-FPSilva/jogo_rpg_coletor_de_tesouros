extends Control

func _on_btn_novamente_pressed():
	get_tree().change_scene_to_file("res://Men.tscn")

func _on_btn_menu_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
