extends Node2D

@onready var tile_map = $"../TileMap"

var astar_grid: AStarGrid2D
var current_path: Array[Vector2i]
var current_position: Vector2i

func _ready():
	astar_grid = tile_map.astar_grid
	
	astar_grid.set_point_solid(tile_map.local_to_map(global_position))

func _on_move_pressed():
	
	current_position = tile_map.local_to_map(global_position)
	var destination = tile_map.local_to_map( Vector2(global_position.x, global_position.y) ) 
	destination.x = destination.x - 1
	
	#Tratar possiveis caminhos bloqueados
	print(current_position, destination)
	
	var Path = astar_grid.get_id_path(current_position, destination).slice(1)
	
	current_path = Path
	astar_grid.set_point_solid(current_position, false)

func _physics_process(delta):
	if current_path.is_empty():
		return
	
	var target = tile_map.map_to_local(current_path.front())
	
	global_position = global_position.move_toward(target, 10)
	
	if global_position == target:
		current_path.pop_front()
		astar_grid.set_point_solid(tile_map.local_to_map(global_position))
		
		
		
		
