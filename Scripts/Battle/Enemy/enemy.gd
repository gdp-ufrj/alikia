extends Node2D

@onready var tile_map = $"../../TileMap"
@onready var player = $"../../Player"

var astar_grid: AStarGrid2D
var current_path: Array[Vector2i]
var current_position: Vector2i

func _ready():
	astar_grid = tile_map.astar_grid
	
	astar_grid.set_point_solid(tile_map.local_to_map(global_position))

func move(target):
	
	current_position = tile_map.local_to_map(global_position) 

	if current_position in player.get_neighbours(): #ignora o movimento do inimigo se ele ja estiver do lado do jogador
		return
	
	var Path = astar_grid.get_id_path(current_position, target).slice(1)
	
	current_path.append(Path.front())
	
	if Path.front(): #atualizar o local anterior o proximo como solido ou não
		astar_grid.set_point_solid(current_position, false)
		astar_grid.set_point_solid(Path.front(), true)

func _physics_process(_delta):
	if current_path.is_empty():
		return
	
	var target = tile_map.map_to_local(current_path.front())
	
	global_position = global_position.move_toward(target, 10)
	
	if global_position == target:
		current_path.pop_front()
		astar_grid.set_point_solid(tile_map.local_to_map(global_position))
