extends Control

@export var card_mana : Label
@export var animatedSprite : AnimatedSprite2D

func set_card_info(card : CardData):
	card_mana.text = str(card.mana)
	animatedSprite.play(Enums.card_type_to_str(card.card_type))
