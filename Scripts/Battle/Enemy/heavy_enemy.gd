extends Node2D

signal die(enemy)

@onready var tile_map = $"../../TileMap"
@onready var player = $"../../Player"
@onready var obstacles = $"../../Obstacles"
@onready var effect = $Effect
@onready var ap = $AnimationPlayer


var astar_grid: AStarGrid2D
var current_path: Array[Vector2i]
var current_position: Vector2i
var damage: int = 7
var hp: int
var is_stunned: bool = false

func _ready():
	var health_bar = $HealthBar
	astar_grid = tile_map.astar_grid
	astar_grid.set_point_solid(tile_map.local_to_map(global_position))
	hp = 20
	health_bar.max_value = hp
	update_health_bar()
	
func move(target, move_range = 1, is_push = false):
	if !is_push and is_stunned:
		is_stunned = false
		return
	
	
	current_position = tile_map.local_to_map(global_position) 
	var front = Vector2i(current_position.x, current_position.y + 1)
	
	if (front == tile_map.local_to_map(player.global_position)) and !is_push: #ignora o movimento do inimigo se ele ja estiver do lado do jogador
		print("Ataque")
		attack()
		return
	
	if !is_push:
		#ignora o movimento do inimigo se ele ja estiver do lado do obastaculo
		for ob in obstacles.get_children():
			for pos in ob.current_position:
				if front == tile_map.local_to_map(pos):
					ob.take_damage(damage)
					return
	
	if astar_grid.is_point_solid(front) and !is_push:
		return
	elif !is_push:
		target = front
		
	if is_push:
		effect.effect_wind()
	
	
	astar_grid.set_point_solid(current_position, false)
	var Path = astar_grid.get_id_path(current_position, target).slice(move_range)
	
	current_path.append(Path.front())
	
	if Path.front(): #atualizar o local anterior o proximo como solido ou não
		astar_grid.set_point_solid(Path.front(), true)
		astar_grid.set_point_solid(current_position, false)

func _physics_process(_delta):
	if current_path.is_empty():
		return
	
	var target = tile_map.map_to_local(current_path.front())
	
	ap.play("jump_front")
	global_position = global_position.move_toward(target, 2)
	
	
	
	if global_position == target:
		current_path.pop_front()
		astar_grid.set_point_solid(tile_map.local_to_map(global_position))
		ap.play("idle")
		
func attack():
	player.take_damage(damage)
	
func take_damage(damage_took, type = -1):
	print(name, " Levou ", damage_took, "de dano")
	match type:
		0:
			effect.effect_fire()
		1:
			print("Oi")
			effect.effect_thunder()
	hp = hp - damage_took
	if(hp <= 0): _die()
	update_health_bar()
	
func _die():
	$heavyDeath.play()
	
func _on_heavy_death_finished():
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
	effect.effect_water()

