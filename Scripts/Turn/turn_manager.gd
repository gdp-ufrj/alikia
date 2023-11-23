extends Node2D

signal pass_turn(turn : int)

@export var turn_label_count : Label

var turn : int

func _ready():
	turn = 1
	turn_label_count.text = str(turn)


func _on_turn_button_pressed():
	turn += 1
	turn_label_count.text = str(turn)
	pass_turn.emit(turn)
