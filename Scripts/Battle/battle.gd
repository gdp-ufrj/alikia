extends Node2D

signal move_enemies
signal allow_player_move
signal used_card(card: CardData)


func _on_turn_manager_pass_turn(_turn):
	move_enemies.emit()
	allow_player_move.emit()

func _on_deck_system_use_card(card):
	used_card.emit(card)
	
	
	