extends Control

var main_scn = preload("res://Main/Main.tscn")

func _on_Button_button_down():
	get_tree().change_scene_to(main_scn)
