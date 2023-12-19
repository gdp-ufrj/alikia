extends Node2D

@onready var player = $"../Player"
@onready var tile_map = $"../TileMap"
@onready var marker_2d = $"../Marker2D"
@onready var marker_2d_2 = $"../Marker2D2"

var enemy_1 = load("res://Scenes/enemy.tscn")

var enemies: Array
var astar_grid: AStarGrid2D
var target: Vector2i
var neighbours: Array[Vector2i]
var test = true
var count = 0

func _ready():
	enemies = get_children()
	astar_grid = tile_map.astar_grid
	
	target = tile_map.local_to_map(player.global_position) #seta o alvo como a posição do jogador
	neighbours = tile_map.get_surrounding_cells(target) #pega os vizinhos do alvo 

func _on_battle_move_enemies():
	count = count + 1
	for enemy in enemies:
		if !(target == tile_map.local_to_map(player.global_position)):
			target = tile_map.local_to_map(player.global_position) #seta o alvo como a posição do jogador
			neighbours = tile_map.get_surrounding_cells(target) #pega os vizinhos do alvo 
		
		if(astar_grid.is_point_solid(neighbours.front())):
			print('Vizinhos novos', neighbours)
			neighbours = neighbours.slice(1) #Tira o primeiro vizinho da lista se ja estiver ocupado o local
		
		enemy.move(neighbours.front())	
	
		#var enemy_spawn = randf_range(0, enemies.size())
		
	if count % 3 == 0:
		_create_enemy()
	if count % 7 == 0:
		_create_enemy()
		
	#if test == true:
		#$Enemy.position = marker_2d.position
		#test = false
	
		
		#await get_tree().create_timer(0.5).timeout #timer para o movimento de cada inimigo

func _create_enemy():
	var scene = enemy_1.instantiate()
	scene.position = marker_2d.position
	add_child(scene)
	enemies.append(scene)
	scene.die.connect(self._on_enemy_die)
	
func _on_enemy_die(enemy):
	enemies.erase(enemy)
	astar_grid.set_point_solid(tile_map.local_to_map(enemy.global_position), false)
	enemy.queue_free()
