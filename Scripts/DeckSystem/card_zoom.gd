extends Control

@export var card_name_label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_hand_on_card_zoom_enter(card):
	card_name_label.text = card
	visible = true


func _on_hand_on_card_zoom_exit():
	visible = false
