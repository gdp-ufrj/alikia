extends Node2D

@onready var label := $CreditsContainer/Label
@export var timer_delay : float
@export var empty_lines : int
var lines_skipped = 0
var timer : Timer = null
var total_lines : int = 0

func _ready():
	total_lines = label.get_line_count() + empty_lines
	timer = Timer.new()
	add_child(timer)
	
	timer.timeout.connect(self._skip_line)
	timer.set_wait_time(timer_delay)
	timer.set_one_shot(false)
	timer.start()
	
	for i in range(empty_lines):
		label.text = '\n' + label.text

func _input(event):
	if event.is_action_pressed("MouseClick") == false:
		return
	_exit_scene()

func _skip_line():
	lines_skipped += 1
	label.lines_skipped = lines_skipped
	if(lines_skipped == total_lines):
		_exit_scene()

func _exit_scene():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
