extends Node2D

signal on_card_zoom_enter(card : CardData)
signal on_card_zoom_exit

@export var starting_mana : int = 1
@export var max_mana : int = 20
@export var deck : Node2D
@export var hand_buttons_control : HBoxContainer
@export var mana_count_label : Label

var hand : Array
var currentMana : int

func _ready():
	currentMana = starting_mana
	mana_count_label.text = str(currentMana)

func on_use_card(used_card, used_button):
	if(currentMana < used_card.mana): return
	print(used_card.name)
	
	currentMana -= used_card.mana
	mana_count_label.text = str(currentMana)
	
	deck.on_use_card(used_card)
	used_button.queue_free()
	
	card_zoom_exit()

func card_zoom_enter(card):
	on_card_zoom_enter.emit(card)
	
func card_zoom_exit():
	on_card_zoom_exit.emit()

func _on_button_2_pressed():
	var card : CardData = deck.buy_card()
	hand.push_back(card)
	
	var button : = Button.new()
	button.text = card.name
	
	hand_buttons_control.add_child(button)
	button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	button.pressed.connect(self.on_use_card.bind(card, button))
	button.mouse_entered.connect(self.card_zoom_enter.bind(card))
	button.mouse_exited.connect(self.card_zoom_exit.bind())
	

func _on_turn_manager_pass_turn(turn):
	currentMana = clamp(currentMana + turn, 0, max_mana)
	mana_count_label.text = str(currentMana)
	print('--------------')
	print('Turn: ', turn)
	print('CurrentMana: ', currentMana)
