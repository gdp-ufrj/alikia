extends Control

@export var card_img : TextureRect
@export var card_mana : Label

func set_card_info(card : CardData):
	card_img.texture = card.mainImage
	card_mana.text = str(card.mana)
