extends Node2D

@onready var tile_map = $"../TileMap"

var astar_grid: AStarGrid2D
var current_path: Array[Vector2i]
var moving : bool = false
var range_path : Array[Vector2i]
var show_range : bool = true
var current_position : Vector2i


func _ready():
	astar_grid = tile_map.astar_grid
	astar_grid.set_point_solid(tile_map.local_to_map(global_position))


func _input(event):
	if event.is_action_pressed("MouseClick") == false:
		return
	
	if tile_map.local_to_map(get_global_mouse_position()) not in range_path:
		return
	
	clear_tiles(range_path)
	range_path.clear()
	
	var destination = tile_map.local_to_map(get_global_mouse_position())
	current_position = tile_map.local_to_map(global_position)
	
	var Path = astar_grid.get_id_path(current_position, destination).slice(1)
	astar_grid.set_point_solid(current_position, false)
	
	
	if !Path.is_empty() and !moving:
		current_path = Path
		astar_grid.set_point_solid(current_path.back())
		

func _physics_process(delta):
	if show_range and !moving:
		current_position = tile_map.local_to_map(global_position)
		range_path = get_tiles_in_range(current_position, 3)
		show_tiles(range_path)
		show_range = false
		
	if current_path.is_empty() and !moving and range_path.is_empty():
		show_range = true
	
	if current_path.is_empty():
		current_position = tile_map.local_to_map(global_position)
		moving = false
		return

	
	var target = tile_map.map_to_local(current_path.front())
	moving = true
	global_position = global_position.move_toward(target, 10)
	
	if global_position == target:
		current_path.pop_front()
		
func show_tiles(tiles: Array[Vector2i]):
	for i in tiles:
		tile_map.set_cell(1, i, 1, Vector2i(0,0))
		
func clear_tiles(tiles: Array[Vector2i]):
	for i in tiles:
		tile_map.set_cell(1, i, -1, Vector2i(-1,-1))

func get_tiles_in_range(start: Vector2i, range_player: int):
	var tiles_in_range: Array[Vector2i] = []
	
	var step = 0
	
	var neighbours : Array[Vector2i] = tile_map.get_surrounding_cells(start)
	neighbours.append(start)
	
	while  step < range_player:
		var new_neighbours : Array[Vector2i] = []
		for i in neighbours:
			var neighbour_path = astar_grid.get_id_path(start, i)
			if astar_grid.is_in_boundsv(i) and (i not in tiles_in_range) and (len(neighbour_path) <= range_player + 1 ) and !(astar_grid.is_point_solid(i)):
				tiles_in_range.append(i)
				new_neighbours.append_array(tile_map.get_surrounding_cells(i))
		neighbours.append_array(new_neighbours)
		step += 1
	tiles_in_range.erase(start)
	return tiles_in_range
	
func get_neighbours():
	return tile_map.get_surrounding_cells(current_position)
