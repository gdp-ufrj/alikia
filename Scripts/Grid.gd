extends Node2D

@onready var tile_map = $"../TileMap"

var astar_grid: AStarGrid2D

func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16,16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(x + tile_map.get_used_rect().position.x, y + tile_map.get_used_rect().position.y)
			var tile_data = tile_map.get_cell_tile_data(2, tile_position)
			if !(tile_data == null or tile_data.get_custom_data("obstacle") == false):
				astar_grid.set_point_solid(tile_position, true)
				
				
