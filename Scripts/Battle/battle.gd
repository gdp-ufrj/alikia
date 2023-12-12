extends Node2D

signal move_enemies

func _on_turn_manager_pass_turn(_turn):
	move_enemies.emit()
