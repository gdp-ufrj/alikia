extends Control

func _on_começar_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")


func _on_creditos_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_sair_pressed():
	get_tree().quit()
