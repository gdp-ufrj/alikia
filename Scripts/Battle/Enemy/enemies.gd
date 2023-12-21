extends Node2D

signal killed_all_enemies

@export var max_enemies : int
var enemies_killed : int = 0
var enemies_spawned : int = 0

@onready var player = $"../Player"
@onready var tile_map = $"../TileMap"
@onready var marker_2d = $"../Marker2D"
@onready var marker_2d_2 = $"../Marker2D2"

var enemy_1 = load("res://Scenes/enemy.tscn")
var enemy_heavy = load("res://Scenes/heavy_enemy.tscn")
var quick_enemy = load("res://Scenes/quick_enemy.tscn")
var enemy_options : Array

var enemies: Array
var astar_grid: AStarGrid2D
var neighbours: Array[Vector2i]
var player_position: Vector2i
var targets: Array[Vector2i]
var test = true
var count = 0

func _ready():
	enemy_options = [enemy_1, enemy_heavy, quick_enemy]
	enemies = get_children()
	astar_grid = tile_map.astar_grid
	
	print(tile_map.get_used_rect().end)
	for i in range(0, tile_map.get_used_rect().size.x):
		targets.append(Vector2i(tile_map.get_used_rect().end.x - 1 - i ,tile_map.get_used_rect().end.y - 1))
		#tile_map.set_cell(1, Vector2i(tile_map.get_used_rect().end.x - 1 - i ,tile_map.get_used_rect().end.y -1), 1, Vector2i(0,0))
	print(targets)
	

func _on_battle_move_enemies():
	count = count + 1
	
	for enemy in enemies:
		if tile_map.local_to_map(enemy.global_position) in targets:
			player.take_damage(enemy.damage)
		else:
			print("OI ")
			var total_distance = 1000000
			var target = tile_map.local_to_map(enemy.global_position)
			for i in targets:
				var path_size = astar_grid.get_id_path(tile_map.local_to_map(enemy.global_position), i).size()
				
				if !astar_grid.is_point_solid(i) and path_size < total_distance:
					target = i
					total_distance = path_size
			
			if target != tile_map.local_to_map(enemy.global_position):
				enemy.move(target)
			else:
				var total_cost = 1000000
				
				player_position = tile_map.local_to_map(player.global_position) #seta o alvo como a posição do jogador
				neighbours = tile_map.get_surrounding_cells(player_position) #pega os vizinhos do alvo 
				
				
				var destination = target
				
				for i in neighbours:
					var path_size = astar_grid.get_id_path(tile_map.local_to_map(enemy.global_position), i).size()
					
					
					if !astar_grid.is_point_solid(i) and path_size < total_cost:
						destination = i
						total_cost = path_size
				if destination != target:	
					enemy.move(target)
			
	if count % 3 == 0:
		_create_enemy()
	if count % 5 == 0:
		_create_enemy()
		
	#if test == true:
		#$Enemy.position = marker_2d.position
		#test = false
	
		
		#await get_tree().create_timer(0.5).timeout #timer para o movimento de cada inimigo

func _create_enemy():
	if(max_enemies == enemies_spawned): return
	var scene = enemy_options[randi() % enemy_options.size()].instantiate()
	scene.position = marker_2d.position
	add_child(scene)
	enemies.append(scene)
	scene.die.connect(self._on_enemy_die)
	enemies_spawned += 1
	
func _on_enemy_die(enemy):
	enemies_killed += 1
	enemies.erase(enemy)
	astar_grid.set_point_solid(tile_map.local_to_map(enemy.global_position), false)
	enemy.queue_free()
	if(max_enemies == enemies_killed):
		killed_all_enemies.emit()
