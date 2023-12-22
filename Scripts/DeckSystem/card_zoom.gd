extends Control

@export var card_name_label : Label
@export var card_mana_label : Label
@export var animatedSprite : AnimatedSprite2D

func _ready():
	visible = false

func _on_hand_on_card_zoom_enter(card:CardData):
	card_name_label.text = card.name
	card_mana_label.text = str(card.mana)
	animatedSprite.play(Enums.card_type_to_str(card.card_type))
	visible = true

func _on_hand_on_card_zoom_exit():
	visible = false
