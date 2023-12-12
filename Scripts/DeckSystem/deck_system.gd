extends Node2D

signal pass_turn(turn : int)

func _on_turn_manager_pass_turn(turn):
	pass_turn.emit(turn)
