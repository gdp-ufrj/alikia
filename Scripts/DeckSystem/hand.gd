extends Node2D

signal on_card_zoom_enter(card : String)
signal on_card_zoom_exit

@export var deck : Node2D
@export var hand_buttons_control : HBoxContainer

var hand : Array
var card_buttons : Dictionary

func _ready():
	card_buttons = {}


func _process(_delta):
	pass


func on_use_card(used_card):
	print(used_card)
	deck.on_use_card(used_card)
	card_buttons[used_card].visible = false
	card_zoom_exit()

func card_zoom_enter(card):
	on_card_zoom_enter.emit(card)
	
func card_zoom_exit():
	on_card_zoom_exit.emit()

func _on_button_2_pressed():
	var card : String = deck.buy_card()
	hand.push_back(card)
	
	if(card in card_buttons):
		var card_button : Button = card_buttons[card]
		card_button.visible = true
		hand_buttons_control.move_child(card_button, -1)
		return
	
	var button : = Button.new()
	button.text = card
	card_buttons[card] = button
	
	hand_buttons_control.add_child(button)
	button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	button.pressed.connect(self.on_use_card.bind(card))
	button.mouse_entered.connect(self.card_zoom_enter.bind(card))
	button.mouse_exited.connect(self.card_zoom_exit.bind())
	
