extends Node2D

@onready var tile_map = $"../../TileMap"
@onready var sprite = $Sprite2D
@onready var sprite2 = $Sprite2D2
@onready var effect = $Effect
@onready var effect2 = $Effect2

var astar_grid: AStarGrid2D
var current_position: Array[Vector2]
var hp: int

func _ready():
	astar_grid = tile_map.astar_grid
	
	current_position.append(sprite.global_position)
	current_position.append(sprite2.global_position)
		
	astar_grid.set_point_solid(tile_map.local_to_map(sprite.global_position), true)
	astar_grid.set_point_solid(tile_map.local_to_map(sprite2.global_position), true)
	
	print(current_position)
	hp = 9
	update_health_bar()
	

func take_damage(damage_took, type = -1):
	print(name, " Levou ", damage_took, "de dano")
	match type:
		0:
			effect.effect_fire()
			effect2.effect_fire()
		1:
			print("Oi")
			effect.effect_thunder()
			effect2.effect_thunder()
	hp = hp - damage_took
	
	if(hp <= 0):
		await get_tree().create_timer(1.0).timeout
		_die()
	update_health_bar()
	
	
func _die():
	astar_grid.set_point_solid(tile_map.local_to_map(sprite.global_position), false)
	astar_grid.set_point_solid(tile_map.local_to_map(sprite2.global_position), false)
	queue_free()

func update_health_bar():
	var health_bar = $HealthBar
	health_bar.value = hp

	
