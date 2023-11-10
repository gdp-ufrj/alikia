extends Node2D

var cards : Array
var discard_deck : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	cards = ["A", "B", "C"]
	cards.shuffle()
	discard_deck = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shuffle_deck():
	cards = discard_deck
	discard_deck = []
	cards.shuffle()
	
func buy_card():
	if(len(cards) == 0):
		shuffle_deck()
		
	if(len(cards) == 0): return null
		
	var card : String = cards.pop_front()
	return card

func on_use_card(used_card):
	discard_deck.push_front(used_card)

