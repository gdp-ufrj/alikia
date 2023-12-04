extends Node2D

@onready var tile_map = $"../../TileMap"
@onready var player = $"../../Player"

var astar_grid: AStarGrid2D
var current_path: Array[Vector2i]
var current_position: Vector2i
var target: Vector2i
var damage: int = 3
var hp: int

func _ready():
	astar_grid = tile_map.astar_grid
	astar_grid.set_point_solid(tile_map.local_to_map(global_position))
	hp = 20
	update_health_bar()
	
func move(target):
	
	current_position = tile_map.local_to_map(global_position) 

	if current_position in player.get_neighbours(): #ignora o movimento do inimigo se ele ja estiver do lado do jogador
		attack()
		return
	
	var Path = astar_grid.get_id_path(current_position, target).slice(1)
	
	current_path.append(Path.front())
	
	if Path.front(): #atualizar o local anterior o proximo como solido ou não
		astar_grid.set_point_solid(Path.front(), true)
		astar_grid.set_point_solid(current_position, false)

func _physics_process(delta):
	if current_path.is_empty():
		return
	
	var target = tile_map.map_to_local(current_path.front())
	
	global_position = global_position.move_toward(target, 10)
	
	if global_position == target:
		current_path.pop_front()
		astar_grid.set_point_solid(tile_map.local_to_map(global_position))
		
func attack():
	player.take_damage(damage)
	
func take_damage(damage):
	hp = hp - damage
	update_health_bar()

func update_health_bar():
	var health_bar = $HealthBar
	health_bar.value = hp
		
		
		
