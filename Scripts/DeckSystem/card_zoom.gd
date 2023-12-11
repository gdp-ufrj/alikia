extends Control

@export var card_name_label : Label
@export var card_mana_label : Label
@export var card_description_label : Label
@export var card_image_label : TextureRect #Depois verificar necessidade de trocar para Texture2D




# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_hand_on_card_zoom_enter(card:CardData):
	card_name_label.text = card.name
	card_mana_label.text = str(card.mana)
	card_description_label.text = card.description
	card_image_label.texture = card.mainImage
	visible = true
	

func _on_hand_on_card_zoom_exit():
	visible = false
