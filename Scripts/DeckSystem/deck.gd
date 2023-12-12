extends Node2D


@export var deck_count_label : Label
@export var discard_count_label : Label
@export var equipped_cards: Array[CardData]
@export var equipped_cards_quantity: Array[int]


var cards : Array
var discard_deck : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	discard_deck = _create_deck() 
	shuffle_deck()

func _create_deck():
	var deck = []
	for card_index in range(len(equipped_cards)):
		for qtd in range(equipped_cards_quantity[card_index]):
			deck.push_back(equipped_cards[card_index])
	return deck
	
func shuffle_deck():
	cards = discard_deck
	discard_deck = []
	cards.shuffle()
	deck_count_label.text = str(len(cards))
	discard_count_label.text = str(0)
	
func buy_cards(quantity : int = 1):
	var bought_cards : Array[CardData] = []
	
	for i in range(quantity):
		var card : CardData = _get_card()
		bought_cards.append(card)
	
	deck_count_label.text = str(len(cards))
	return bought_cards
	
func _get_card():
	if(len(cards) == 0): shuffle_deck()
	return cards.pop_front()

func on_use_card(used_card):
	discard_deck.push_front(used_card)
	discard_count_label.text = str(len(discard_deck))
	
