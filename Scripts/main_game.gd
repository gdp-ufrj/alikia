extends Node2D

func _on_battle_end_game(result):
	if(result):
		get_tree().change_scene_to_file("res://Scenes/Ending/victory.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Ending/defeat.tscn")
