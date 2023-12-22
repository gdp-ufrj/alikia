extends Control

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("Pause") == false:
		return
	visible = !visible
		
func _on_continue_pressed():
	visible = false

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_pause_buttom_pressed():
	visible = !visible
