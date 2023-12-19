extends Node2D

signal pass_turn(turn : int)
signal use_card(card : CardData)
signal allow_new_card_use

func _on_turn_manager_pass_turn(turn):
	pass_turn.emit(turn)

func _on_hand_on_use_card_signal(card):
	use_card.emit(card)


func _on_battle_allow_new_card_use():
	allow_new_card_use.emit()
