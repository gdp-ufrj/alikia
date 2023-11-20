extends Node2D

@onready var player = $"../Player"
@onready var tile_map = $"../TileMap"

var enemies: Array
var astar_grid: AStarGrid2D
var target: Vector2i
var neighbours: Array[Vector2i]

func _ready():
	enemies = get_children()
	astar_grid = tile_map.astar_grid

func _on_move_pressed():
	
	for enemy in enemies:
		if !(target == tile_map.local_to_map(player.global_position)) :
			target = tile_map.local_to_map(player.global_position) #seta o alvo como a posição do jogador
			neighbours = tile_map.get_surrounding_cells(target) #pega os vizinhos do alvo 
		
		print(neighbours)
		if(astar_grid.is_point_solid(neighbours.front())):
			print('Vizinhos novos', neighbours)
			neighbours = neighbours.slice(1) #Tira o primeiro vizinho da lista se ja estiver ocupado o local
			
		enemy.move(neighbours.front())	
		
		#await get_tree().create_timer(0.5).timeout #timer para o movimento de cada inimigo
