extends Node2D

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


func _on_button_2_pressed():
	var card : String = deck.buy_card()
	hand.push_back(card)
	
	var button : = Button.new()
	button.text = card
	button.pressed.connect(self.on_use_card.bind(card, button))
	hand_buttons_control.add_child(button)
	button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
