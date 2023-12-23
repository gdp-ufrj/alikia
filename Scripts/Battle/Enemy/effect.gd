extends Node2D

@onready var ap = $AnimationPlayer

func effect_water():
	ap.play("water")
	
	ap.queue("idle")

func effect_fire():
	ap.play("fire")
	
	ap.queue("idle")

func effect_thunder():
	ap.play("thunder")
	
	ap.queue("idle")

func effect_wind():
	ap.play("wind")
	
	ap.queue("idle")


func _on_animation_player_animation_changed(old_name, new_name):
	pass # Replace with function body.
