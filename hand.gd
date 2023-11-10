extends Node2D

@export var deck : Node2D
@export var min_x_hand : float
@export var max_x_hand : float

var hand : Array
var buttons : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print(buttons)
	#pass


func on_use_card(used_card, used_button):
	# Usar carta
	print(used_card)
	deck.on_use_card(used_card)
	buttons.erase(used_button)
	remove_child(used_button)


func _on_button_2_pressed():
	var card : String = deck.buy_card()
	hand.push_back(card)
	
	var button : = Button.new()
	button.text = card
	button.pressed.connect(self.on_use_card.bind(card, button))
	add_child(button)
	buttons.push_back(button)
