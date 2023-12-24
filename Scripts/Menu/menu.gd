extends Control

@onready var ui_play_sound = $uiPlay
@onready var ui_credits_sound = $uiCredits
@onready var ui_exit_sound = $uiExit
@onready var exitButton = $MarginContainer/HBoxContainer/Exit

func _ready():
	if OS.get_name() == "Web":
		exitButton.hide()

func _on_start_pressed():
	ui_play_sound.play()
	#get_tree().change_scene_to_file("res://Scenes/Cutscene/cutscene.tscn")
func _on_credits_pressed():
	ui_credits_sound.play()
	#get_tree().change_scene_to_file("res://Scenes/Credits/credits.tscn")
func _on_exit_pressed():
	#print("Sair")
	ui_exit_sound.play()
	#get_tree().quit()


func _on_ui_play_finished():
	get_tree().change_scene_to_file("res://Scenes/Cutscene/cutscene.tscn")
	
func _on_ui_credits_finished():
	get_tree().change_scene_to_file("res://Scenes/Credits/credits.tscn")

func _on_ui_exit_finished():
	get_tree().quit()



