extends Node2D

@onready var tile_map = $"../TileMap"
@onready var player_health_bar = $"../PlayerHealthBar"
@onready var enemies = $"../Enemies"
@onready var obstacles = $"../Obstacles"

var astar_grid: AStarGrid2D
var current_path: Array[Vector2i]
var range_path: Array[Vector2i]

var current_position : Vector2i

var moving: bool = false
var show_range: bool = false
var allow_movement: bool = true
var showing_tiles: bool = false

var in_range_enemies = {}

var hp: int
var range: int

func _ready():
	astar_grid = tile_map.astar_grid
	astar_grid.set_point_solid(tile_map.local_to_map(global_position))
	hp = 100
	range = 3
	
	update_health_bar()

func _input(event):
	if event.is_action_pressed("MouseClick") == false:
		return
	
	
	current_position = tile_map.local_to_map(global_position)
	var destination = tile_map.local_to_map(get_global_mouse_position())
	
	#Tratar input no ataque basico
	if !in_range_enemies.is_empty():
		if in_range_enemies.has(destination):
			print("Atacou  ", destination)
			print(in_range_enemies.get(destination))
			in_range_enemies.get(destination).take_damage(3)
			
			for key in in_range_enemies.keys():
				tile_map.set_cell(1, Vector2i(key[0],key[1]), -1, Vector2i(-1,-1))
			in_range_enemies = {}
		
	#tratar input no movimento
	if (event.is_action("MouseClick") == true and allow_movement == true) and range > 0:
		move(destination)
	
	
	
	#if destination == current_position:
		#show_range = true
		#in_range_enemies = show_enemies_in_range(current_position, 1)
	
	#if destination not in range_path and !(in_range_enemies.has(destination)):
	#	return
		
		
	#if in_range_enemies.has(destination):
	#	print("Atacou  ", destination)
	#	in_range_enemies.get(destination).take_damage(3)
	#	
	#	for key in in_range_enemies.keys():
	#		tile_map.set_cell(1, Vector2i(key[0],key[1]), -1, Vector2i(-1,-1))
	#	in_range_enemies = {}
	
	

func _physics_process(delta):
	
	if show_range and !moving:
		current_position = tile_map.local_to_map(global_position)
		range_path = get_tiles_in_range(current_position, range)
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
	showing_tiles = true

func clear_tiles(tiles: Array[Vector2i]):
	for i in tiles:
		tile_map.set_cell(1, i, -1, Vector2i(-1,-1))
	for key in in_range_enemies.keys():
			tile_map.set_cell(1, Vector2i(key[0],key[1]), -1, Vector2i(-1,-1))
	in_range_enemies = {}
	showing_tiles = false

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
	
	var list_enemies: Array[Node]
	var list_enemies_in_range = {}
	var list_obstacles: Array[Node]
	
	var enemies_dict = {}
	var obstacle_dict = {}
	
	list_enemies = enemies.get_children()
	list_obstacles = obstacles.get_children()

	
	for enemy in list_enemies:
		var enemy_position = tile_map.local_to_map(enemy.global_position)
		enemies_dict[enemy_position] = enemy
	
	
	
	for obstacle in list_obstacles:
		var positions = obstacle.current_position
		print('Posiçoes', positions)
		for position in positions:
			var obstacle_position = tile_map.local_to_map(position)
			obstacle_dict[obstacle_position] = obstacle
	
	print(obstacle_dict)
	
	for x in range(-range, range+1):
		for y in range(-range,range+1):
			var i = Vector2i(x + start.x, y + start.y)
			if enemies_dict.has(i):
				list_enemies_in_range[i] = enemies_dict.get(i)
			if obstacle_dict.has(i):
				list_enemies_in_range[i] = obstacle_dict.get(i)
	
	
	return list_enemies_in_range

func show_enemies_in_range(start: Vector2i, range: int):
	var enemies_in_range = get_enemies_in_range(start, range)
	
	for key in enemies_in_range.keys():
		print(key)
		tile_map.set_cell(1, key, 1, Vector2i(0,0))
	
	return enemies_in_range

func move(destination: Vector2i):
	
	if destination == current_position and show_range == false and showing_tiles == false: 
		show_range = true
	elif destination == current_position and  showing_tiles == true:
		clear_tiles(range_path)
		range_path.clear()
	
	if destination not in range_path and !(in_range_enemies.has(destination)):
		return
	
	clear_tiles(range_path)
	range_path.clear()
	
	var Path = astar_grid.get_id_path(current_position, destination).slice(1)
	
	range = range - Path.size()
	
	astar_grid.set_point_solid(current_position, false)
	
	
	if !Path.is_empty() and !moving:
		current_path = Path
		astar_grid.set_point_solid(current_path.back())
	
	pass

func atack():
	in_range_enemies = show_enemies_in_range(current_position, 1)
	
	if in_range_enemies.is_empty():
		return false

func gust():
	for enemy in enemies.get_children():
		enemy.push_back()

func _on_battle_used_card(card):
	
	var card_type = card.card_type
	
	
	if card_type == Enums.CardTypes.ATAQUE:
		var result = atack()
		
		if result == false:
			print("Não usar carta")
		else:
			print("Ataque usado")
	
	if card_type == Enums.CardTypes.LUFADA:
		gust()

func _on_battle_allow_player_move():
	allow_movement = true
	range = 3