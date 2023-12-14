extends Node2D

@onready var tile_map = $"../TileMap"
@onready var sprite = $Sprite2D
@onready var sprite2 = $Sprite2D2

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
	hp = 20
	update_health_bar()
	

func take_damage(damage):
	hp = hp - damage
	update_health_bar()

func update_health_bar():
	var health_bar = $HealthBar
	health_bar.value = hp
	

	
