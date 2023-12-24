extends TextureButton

@export var pass_turn_timer : float

func _pressed():
	disabled = true
	var tempTimer = get_tree().create_timer(pass_turn_timer)
	tempTimer.timeout.connect(func(): disabled = false)
