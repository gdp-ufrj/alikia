extends Control


func _on_voltar_pressed():
	$uiCredReturn.play()


func _on_ui_cred_return_finished():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
