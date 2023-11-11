extends Node2D

@export var deck_count_label : Label
@export var discard_count_label : Label

var cards : Array
var discard_deck : Array
var card_buttons : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	discard_deck = ["A", "B", "C"]
	shuffle_deck()
	card_buttons = {}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shuffle_deck():
	cards = discard_deck
	discard_deck = []
	cards.shuffle()
	deck_count_label.text = str(len(cards))
	discard_count_label.text = str(0)
	
func buy_card():
	if(len(cards) == 0):
		shuffle_deck()
		
	if(len(cards) == 0): return null
		
	var card : String = cards.pop_front()
	deck_count_label.text = str(len(cards))
	return card

func on_use_card(used_card):
	discard_deck.push_front(used_card)
	discard_count_label.text = str(len(discard_deck))

