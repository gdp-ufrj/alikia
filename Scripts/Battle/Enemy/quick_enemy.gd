extends Node2D

signal die(enemy)

@onready var tile_map = $"../../TileMap"
@onready var player = $"../../Player"
@onready var obstacles = $"../../Obstacles"

var astar_grid: AStarGrid2D
var current_path: Array[Vector2i]
var current_position: Vector2i
var damage: int = 3
var hp: int
var is_stunned: bool = false

func _ready():
	var health_bar = $HealthBar
	astar_grid = tile_map.astar_grid
	astar_grid.set_point_solid(tile_map.local_to_map(global_position), true)
	hp = 10
	health_bar.max_value = hp
	update_health_bar()
	
func move(target, range = 2, is_push = false):
	if !is_push and is_stunned:
		is_stunned = false
		return
	
	
	current_position = tile_map.local_to_map(global_position) 
	var front = Vector2i(current_position.x - 1, current_position.y)
	
	
	if (front == tile_map.local_to_map(player.global_position)) and !is_push:
		print("Ataque")
		attack()
		return
	
	
	astar_grid.set_point_solid(current_position, false)
	var Path = astar_grid.get_id_path(current_position, target)
	
	
	
	if Path.size() > range:
		Path = Path.slice(0, range+1)
	else:
		Path = Path.slice(range - 1)
	
	current_path = Path
	

	
	if Path.front(): #atualizar o local anterior o proximo como solido ou não
		astar_grid.set_point_solid(Path.back(), true)
		astar_grid.set_point_solid(current_position, false)

func _physics_process(delta):
	
	if current_path.is_empty():
		return
	
	var target = tile_map.map_to_local(current_path.front())
	var previous = tile_map.local_to_map(global_position)
	

	
	global_position = global_position.move_toward(target, 7)
	
	
	if global_position == target:
		current_path.pop_front()
		
		
func attack():
	player.take_damage(damage)
	
func take_damage(damage):
	print(name, " Levou ", damage, "de dano")
	hp = hp - damage
	if(hp <= 0): _die()
	update_health_bar()
	
func _die():
	die.emit(self)

func update_health_bar():
	var health_bar = $HealthBar
	health_bar.value = hp
	
func push_back():
	current_position = tile_map.local_to_map(global_position) 
	
	var target_1 = Vector2i(current_position.x, current_position.y-1)
	var target_2 = Vector2i(current_position.x, current_position.y-2)
	
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

func stun():
	is_stunned = true
