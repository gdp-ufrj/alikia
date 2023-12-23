extends Control

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("Pause") == false:
		return
	visible = !visible
		
func _on_continue_pressed():
	$uiContinue.play()
	visible = false

func _on_quit_pressed():
	$uiPauseExit.play()

func _on_pause_buttom_pressed():
	$uiMainPause.play()
	visible = !visible


func _on_ui_pause_exit_finished():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
