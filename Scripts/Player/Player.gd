extends Node2D

@onready var tile_map = $"../TileMap"
@onready var player_health_bar = $"../PlayerHealthBar"
@onready var enemies = $"../Enemies"

var astar_grid: AStarGrid2D
var current_path: Array[Vector2i]
var moving : bool = false
var range_path : Array[Vector2i]
var show_range : bool = false
var current_position : Vector2i
var in_range_enemies = {}
var hp: int

func _ready():
	astar_grid = tile_map.astar_grid
	astar_grid.set_point_solid(tile_map.local_to_map(global_position))
	hp = 100
	update_health_bar()

func _input(event):
	if event.is_action_pressed("MouseClick") == false:
		return
	
	current_position = tile_map.local_to_map(global_position)
	var destination = tile_map.local_to_map(get_global_mouse_position())
	
	if destination == current_position:
		show_range = true
		in_range_enemies = show_enemies_in_range(current_position, 1)
		print(in_range_enemies)
		
	
	if destination not in range_path and !(in_range_enemies.has(destination)):
		return
		
	if in_range_enemies.has(destination):
		print("Atacou  ", destination)
		in_range_enemies.get(destination).take_damage(3)
		
		for key in in_range_enemies.keys():
			tile_map.set_cell(1, Vector2i(key[0],key[1]), -1, Vector2i(-1,-1))
		in_range_enemies = {}
	
	clear_tiles(range_path)
	range_path.clear()
	
	
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
	for key in in_range_enemies.keys():
			tile_map.set_cell(1, Vector2i(key[0],key[1]), -1, Vector2i(-1,-1))
	in_range_enemies = {}

func get_tiles_in_range(start: Vector2i, range_player: int):
	var tiles_in_range: Array[Vector2i] = []
	
	var step = 0
	
	var neighbours : Array[Vector2i] = tile_map.get_surrounding_cells(start)
	neighbours.append(start)
	
	while  step < range_player:
		var new_neighbours : Array[Vector2i] = []
		for i in neighbours:
			if astar_grid.is_in_boundsv(i):
				var neighbour_path = astar_grid.get_id_path(start, i)
				if (i not in tiles_in_range) and (len(neighbour_path) <= range_player + 1 ) and !(astar_grid.is_point_solid(i)):
					tiles_in_range.append(i)
					new_neighbours.append_array(tile_map.get_surrounding_cells(i))
		neighbours.append_array(new_neighbours)
		step += 1
	tiles_in_range.erase(start)
	return tiles_in_range

func get_neighbours():
	return tile_map.get_surrounding_cells(current_position)

func take_damage(damage: int):
	hp = hp - damage
	update_health_bar()

func update_health_bar():
	player_health_bar.value = hp

func get_enemies_in_range(start: Vector2i, range: int):
	
	var list_enemies : Array[Node]
	var list_enemies_in_range = {}
	
	var enemies_dict = {}
	
	list_enemies = enemies.get_children()
	
	for enemy in list_enemies:
		var enemy_position = tile_map.local_to_map(enemy.global_position)
		enemies_dict[enemy_position] = enemy
	
	var tiles_in_range: Array[Vector2i] = []
	
	var step = 0
	
	var neighbours : Array[Vector2i] = tile_map.get_surrounding_cells(start)
	neighbours.append(start)
	
	while  step < range:
		var new_neighbours : Array[Vector2i] = []
		for i in neighbours:
			if enemies_dict.has(i):
				list_enemies_in_range[i] = enemies_dict.get(i)
			if astar_grid.is_in_boundsv(i):
				var neighbour_path = astar_grid.get_id_path(start, i)
				if (i not in tiles_in_range) and (len(neighbour_path) <= range + 1 ) and !(astar_grid.is_point_solid(i)):
					tiles_in_range.append(i)
					new_neighbours.append_array(tile_map.get_surrounding_cells(i))
		neighbours.append_array(new_neighbours)
		step += 1
		
	tiles_in_range.erase(start)
	
	
	return list_enemies_in_range

func show_enemies_in_range(start: Vector2i, range: int):
	var enemies_in_range = get_enemies_in_range(start, range)
	
	for key in enemies_in_range.keys():
		print(key)
		tile_map.set_cell(1, key, 1, Vector2i(0,0))
	
	return enemies_in_range



