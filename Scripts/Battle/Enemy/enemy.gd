extends Node2D

@onready var tile_map = $"../../TileMap"
@onready var player = $"../../Player"

var astar_grid: AStarGrid2D
var current_path: Array[Vector2i]
var current_position: Vector2i
var damage: int = 3
var hp: int

func _ready():
	astar_grid = tile_map.astar_grid
	astar_grid.set_point_solid(tile_map.local_to_map(global_position))
	hp = 20
	update_health_bar()
	
func move(target, range = 1, is_push = false):
	
	current_position = tile_map.local_to_map(global_position) 
	
	print("Current Postion", current_position, name)
	
	if (current_position in player.get_neighbours()) and !is_push: #ignora o movimento do inimigo se ele ja estiver do lado do jogador
		print("Ataque")
		attack()
		return
		
	astar_grid.set_point_solid(current_position, false)
	var Path = astar_grid.get_id_path(current_position, target).slice(range)
	
	
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
	print(name, " Levou ", damage, "de dano")
	hp = hp - damage
	update_health_bar()

func update_health_bar():
	var health_bar = $HealthBar
	health_bar.value = hp

func push_back():
	current_position = tile_map.local_to_map(global_position) 
	
	var target_1 = Vector2i(current_position.x+1, current_position.y)
	var target_2 = Vector2i(current_position.x+2, current_position.y)
	
	if !astar_grid.is_in_boundsv(target_1):
		print("Out of Bound ", name)
		return
	if astar_grid.is_point_solid(target_1):
		print("Solid ", name , target_1)
		return
	if astar_grid.is_in_boundsv(target_2) and !astar_grid.is_point_solid(target_2):
		move(target_2, 2, true)
	else:
		move(target_1, 1, true)
	
