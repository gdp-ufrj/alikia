extends Control


func _on_return_button_pressed():
	$uiEndReturn.play()
	#get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_ui_return_finished():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_ui_end_return_finished():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
