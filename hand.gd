extends Node2D

signal on_card_zoom_enter(card : String)
signal on_card_zoom_exit

@export var deck : Node2D
@export var hand_buttons_control : HBoxContainer

var hand : Array

func _ready():
	pass


func _process(_delta):
	pass


func on_use_card(used_card, used_button):
	print(used_card)
	deck.on_use_card(used_card)
	hand_buttons_control.remove_child(used_button)
	card_zoom_exit()

func card_zoom_enter(card):
	on_card_zoom_enter.emit(card)
	
func card_zoom_exit():
	on_card_zoom_exit.emit()

func _on_button_2_pressed():
	var card : String = deck.buy_card()
	hand.push_back(card)
	
	var button : = Button.new()
	button.text = card
	
	hand_buttons_control.add_child(button)
	button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	button.pressed.connect(self.on_use_card.bind(card, button))
	button.mouse_entered.connect(self.card_zoom_enter.bind(card))
	button.mouse_exited.connect(self.card_zoom_exit.bind())
	
