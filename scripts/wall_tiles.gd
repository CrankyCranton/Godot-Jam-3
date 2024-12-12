class_name WallTiles extends TileMapLayer


func _ready() -> void:
	for cell in get_used_cells():
		process_cell(cell)

func process_cell(cell: Vector2i) -> void:
	var tile_data := get_cell_tile_data(cell)
	if tile_data:
		var SCENE: PackedScene = tile_data.get_custom_data("scene")
		if SCENE:
			var instance := replace_cell(cell, SCENE)
			if instance is Wall:
				instance.init(
					tile_data.get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_SIDE),
					get_cell_atlas_coords(cell) * tile_set.tile_size,
					get_collision_poloygons(tile_data)
				)

				set_cell(cell)


func replace_cell(cell: Vector2i, SCENE: PackedScene) -> Node2D:
	var instance: Node2D = SCENE.instantiate()
	instance.position = map_to_local(cell)
	add_child(instance)
	return instance


func get_collision_poloygons(tile_data: TileData) -> Array[PackedVector2Array]:
	var collision_polygons: Array[PackedVector2Array] = []
	for i in tile_data.get_collision_polygons_count(0):
		collision_polygons.append(tile_data.get_collision_polygon_points(0, i))
	return collision_polygons
