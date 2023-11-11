extends TileMap

var astar_grid: AStarGrid2D

func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = get_used_rect()
	astar_grid.cell_size = tile_set.tile_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()


func _input(event):
	if event.is_action_pressed("MouseClick") == true:
		print(astar_grid.get_id_path(Vector2i(0,0), local_to_map(get_global_mouse_position())) )
		print(astar_grid.is_in_boundsv(local_to_map(get_global_mouse_position())))
	
	
