extends Node2D

signal on_card_zoom_enter(card : CardData)
signal on_card_zoom_exit
signal on_use_card_signal(card : CardData)

@export_category("Starting Values")
@export var starting_mana : int = 1
@export var max_mana : int = 20
@export var starting_hand_size : int = 7
@export var buying_hand_size : int = 3
@export var max_hand_size : int = 7

@export_category("Nodes")
@export var deck : Node2D
@export var hand_buttons_control : HBoxContainer
@export var mana_count_label : Label

@onready var mouse_on_card = $mouseOnCard

var hand : Array[CardData]
var current_mana : int
var can_use_card : bool

func _ready():
	current_mana = starting_mana
	mana_count_label.text = str(current_mana)
	hand = deck.buy_cards(starting_hand_size)
	_create_cards_button(hand)
	can_use_card = true

func on_use_card(used_card, used_button):
	if !can_use_card: return
	
	if(current_mana < used_card.mana): return
	print(used_card.name)
	
	current_mana -= used_card.mana
	mana_count_label.text = str(current_mana)
	
	on_use_card_signal.emit(used_card)
	hand.erase(used_card)
	used_button.queue_free()
	
	card_zoom_exit()

func card_zoom_enter(card):
	on_card_zoom_enter.emit(card)
	mouse_on_card.play()
	
func card_zoom_exit():
	on_card_zoom_exit.emit()

func _create_cards_button(cards : Array[CardData]):	
	for card in cards:
		var button : = Button.new()
		button.text = card.name
		
		hand_buttons_control.add_child(button)
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		button.pressed.connect(self.on_use_card.bind(card, button))
		button.mouse_entered.connect(self.card_zoom_enter.bind(card))
		button.mouse_exited.connect(self.card_zoom_exit.bind())

func _on_deck_system_pass_turn(turn):
	current_mana = clamp(current_mana + turn, 0, max_mana)
	mana_count_label.text = str(current_mana)
	
	var new_cards : Array[CardData] = deck.buy_cards(min(buying_hand_size, max_hand_size - len(hand)))
	hand += new_cards
	_create_cards_button(new_cards)
	print('--------------')
	print('Turn: ', turn)
	print('CurrentMana: ', current_mana)

func _on_deck_system_allow_new_card_use():
	can_use_card = true
