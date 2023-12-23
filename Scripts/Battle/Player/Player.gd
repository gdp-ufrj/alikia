extends Node2D

signal end_card_effect

@onready var tile_map = $"../TileMap"
@onready var player_health_bar = $"../PlayerHealthBar"
@onready var enemies = $"../Enemies"
@onready var obstacles = $"../Obstacles"

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

@onready var rock_barrier_sound = $rockBarrier
@onready var fire_attack_sound = $fireAttack
@onready var air_attack_sound = $airAttack
@onready var basic_attack_sound = $basicAttack
@onready var water_attack_sound = $waterAttack
@onready var lightning_attack_sound = $lightningAttack

@onready var dame_player_sound = $damagePlayer
@onready var hp_label = $"../Control/HPLabel"


var obstacleNode = load("res://Scenes/obstacle.tscn")

var astar_grid: AStarGrid2D
var current_path: Array[Vector2i]
var range_path: Array[Vector2i]

var current_position : Vector2i

var moving: bool = false
var show_range: bool = false
var allow_movement: bool = true
var showing_tiles: bool = false
var attack_card: bool = false
var thunder_card: bool = false
var barrier_card: bool = false

var in_range_enemies = {}
var in_range_fire = {}

var hp: int = 100
var move_range: int
var current_hp: int

func _ready():
	astar_grid = tile_map.astar_grid
	astar_grid.set_point_solid(tile_map.local_to_map(global_position))
	move_range = 3
	hp_label.text = str(hp)
	
	update_health_bar()

func _input(event):
	if event.is_action_pressed("MouseClick") == false:
		return
	
	current_position = tile_map.local_to_map(global_position)
	var destination = tile_map.local_to_map(get_global_mouse_position())
	
	#Tratar input no ataque basico
	if !in_range_enemies.is_empty() and attack_card:
		attack_input(destination, 3)
	
	#Tratar input do raio
	if !in_range_enemies.is_empty() and thunder_card:
		attack_input(destination, 6)
	
	#Tratar input do ataque de fogo
	if !(in_range_fire.is_empty()):
		fire_input(destination)
		end_card_effect.emit()
	
	#Tratar input de spaw da barreira
	if barrier_card:
		barrier_input(destination)
		end_card_effect.emit()
		
	# Se estiver com efeito, nao anda
	if _is_in_effect(): return
	
	#tratar input no movimento
	if (event.is_action("MouseClick") == true and allow_movement == true) and move_range > 0:
		move(destination)

func _physics_process(_delta):
	
	
	if show_range and !moving:
		current_position = tile_map.local_to_map(global_position)
		range_path = get_tiles_in_range(current_position, move_range)
		show_tiles(range_path)
		show_range = false
	
	
	
	if current_path.is_empty():
		current_position = tile_map.local_to_map(global_position)
		moving = false
		sprite.flip_h = false
		ap.play("idle")
		return
	
	var target = tile_map.map_to_local(current_path.front())
	moving = true
	
	if current_position.x < current_path.front().x:
		sprite.flip_h = false
		ap.play("jump")
	elif current_position.x > current_path.front().x:
		sprite.flip_h = true
		ap.play("jump")
	if current_position.y > current_path.front().y:
		ap.play("jump_front")
	elif current_position.y < current_path.front().y:
		ap.play("jump_back")
	
	global_position = global_position.move_toward(target, 2)
	
	
	
	if global_position == target:
		current_path.pop_front()
		current_position = tile_map.local_to_map(global_position)

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

func take_damage(damage: int): #aqui
	hp = hp - damage
	hp_label.text = str(hp)
	dame_player_sound.play()
	update_health_bar()

func update_health_bar():
	player_health_bar.value = hp

func get_enemies_in_range(start: Vector2i, enemies_range: int):
	
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
		var obstacle_positions = obstacle.current_position
		for obstacle_position in obstacle_positions:
			var map_obstacle_position = tile_map.local_to_map(obstacle_position)
			obstacle_dict[map_obstacle_position] = obstacle
	
	for x in range(-enemies_range, enemies_range+1):
		var i = Vector2i(start.x, x + start.y)
		var j = Vector2i(x + start.x,  start.y)
		
		if enemies_dict.has(i):
			list_enemies_in_range[i] = enemies_dict.get(i)
		if obstacle_dict.has(i):
			list_enemies_in_range[i] = obstacle_dict.get(i)
		if enemies_dict.has(j):
			list_enemies_in_range[j] = enemies_dict.get(j)
		if obstacle_dict.has(j):
			list_enemies_in_range[j] = obstacle_dict.get(j)
	
	return list_enemies_in_range

func show_enemies_in_range(enemies_in_range):
	
	for key in enemies_in_range.keys():
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
	
	move_range = move_range - Path.size()
	
	astar_grid.set_point_solid(current_position, false)
	
	
	if !Path.is_empty() and !moving:
		current_path = Path
		astar_grid.set_point_solid(current_path.back())
	
	pass

func attack():
	var enemies_in_range = get_enemies_in_range(current_position, 1)
	if enemies_in_range.is_empty():
		return false
		
	in_range_enemies = show_enemies_in_range(enemies_in_range)
	attack_card = true
	return true

func attack_input(destination, damage):
	if in_range_enemies.has(destination):
		print("Atacou  ", destination)
		in_range_enemies.get(destination).take_damage(damage)
		if attack_card == true:
			basic_attack_sound.play()
		if thunder_card == true:
			lightning_attack_sound.play()
		for key in in_range_enemies.keys():
			tile_map.set_cell(1, Vector2i(key[0],key[1]), -1, Vector2i(-1,-1))
		in_range_enemies = {}
	
	attack_card = false
	thunder_card = false

func gust():
	
	var list_enemies: Array[Node]
	var list_enemies_position: Array[Vector2i] = []
	
	var enemies_dict = {}
	
	list_enemies = enemies.get_children()
	
	for enemy in list_enemies:
		var enemy_position = tile_map.local_to_map(enemy.global_position)
		enemies_dict[enemy_position] = enemy
		list_enemies_position.append(enemy_position)
	
	list_enemies_position.sort()
	
	for enemy_position in list_enemies_position:
		enemies_dict[enemy_position].push_back()
	air_attack_sound.play()
	end_card_effect.emit()

func fire_tornado():  
	var range_fire = get_enemies_in_range(current_position, 3)
	in_range_fire = show_enemies_in_range(range_fire)
	end_card_effect.emit()

func fire_input(destination):
	if in_range_fire.has(destination):
		if destination.x == current_position.x and destination.y < current_position.y:
			for key in in_range_fire.keys():
				if key.x == current_position.x and key.y < current_position.y:
					in_range_fire.get(key).take_damage(7)
		
		if destination.x == current_position.x and destination.y > current_position.y:
			for key in in_range_fire.keys():
				if key.x == current_position.x and key.y > current_position.y:
					in_range_fire.get(key).take_damage(7)
		
		if destination.y == current_position.y and destination.x < current_position.x:
			for key in in_range_fire.keys():
				if key.y == current_position.y and key.x < current_position.x:
					in_range_fire.get(key).take_damage(7)
		
		if destination.y == current_position.y and destination.x > current_position.x:
			for key in in_range_fire.keys():
				if key.y == current_position.y and key.x > current_position.x:
					in_range_fire.get(key).take_damage(7)
		
		for key in in_range_fire.keys():
			tile_map.set_cell(1, Vector2i(key[0],key[1]), -1, Vector2i(-1,-1))
		in_range_fire = {}
		fire_attack_sound.play()

func thunder_range(start: Vector2i, effect_range: int): #aqui raio
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
		var obstacle_positions = obstacle.current_position
		for obstacle_position in obstacle_positions:
			var map_obstacle_position = tile_map.local_to_map(obstacle_position)
			obstacle_dict[map_obstacle_position] = obstacle
	
	for x in range(-effect_range, effect_range+1):
		for y in range(-(effect_range - abs(x)), (effect_range - abs(x))+1):
			var i = Vector2i( x + start.x, y + start.y)
			
			if enemies_dict.has(i):
				list_enemies_in_range[i] = enemies_dict.get(i)
			if obstacle_dict.has(i):
				list_enemies_in_range[i] = obstacle_dict.get(i)
	
	return list_enemies_in_range

func thunder():
	var enemies_in_range = thunder_range(current_position, 6)
	if(enemies_in_range.is_empty()): return false
	in_range_enemies = show_enemies_in_range(enemies_in_range)
	thunder_card = true
	return true

func barrier(): 
	barrier_card = true

func water_drop():
	var list_enemies = enemies.get_children()
	for enemy in list_enemies:
		enemy.stun()
	water_attack_sound.play()
	end_card_effect.emit()

func barrier_input(destination):
	var destination_2 = Vector2i(destination.x + 1, destination.y )
	if !astar_grid.is_in_boundsv(destination) or astar_grid.is_point_solid(destination):
		return
	if  !astar_grid.is_in_boundsv(destination_2) or astar_grid.is_point_solid(destination_2):
		return
	
	print("Destino mapa ", destination)
	print("Destino local ", tile_map.map_to_local(destination))
	
	var scene = obstacleNode.instantiate()
	rock_barrier_sound.play()
	
	scene.position = tile_map.map_to_local(destination) 
	obstacles.add_child(scene)
	
	barrier_card = false

func _on_battle_used_card(card):
	var card_type = card.card_type
	
	if card_type == Enums.CardTypes.ATAQUE:
		var result = attack()
		if !result: end_card_effect.emit()
	if card_type == Enums.CardTypes.LUFADA:
		gust()
	if card_type == Enums.CardTypes.TURBILHAO_CHAMAS:
		fire_tornado()
	if card_type == Enums.CardTypes.BARREIRA_ROCHOSA:
		barrier()
	if card_type == Enums.CardTypes.RAIO:
		var result = thunder()
		if !result: end_card_effect.emit()
	if card_type == Enums.CardTypes.NO_DAGUA:
		water_drop()

func _is_in_effect():
	return barrier_card or thunder_card or attack_card

func _on_battle_allow_player_move():
	allow_movement = true
	move_range = 3
