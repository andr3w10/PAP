extends TileMap

var CONSTANTS = preload("res://Farm/FARM_CONSTANTS.gd")

var tile_pos_infront_of_player

#todo: just process when player see the farm
func _physics_process(_delta):
	if Globals.map != null:
		if Globals.map.farm == null:
			Globals.map.farm = self
	
	var tile_pos_player_is_on = world_to_map(get_global_mouse_position())
	# Here we need to use Face Direction to determine where to put grid helper
	tile_pos_infront_of_player = tile_pos_player_is_on
#	print(str(self.get_cellv(tile_pos_infront_of_player)))
	
	if "tool_type" in Globals.player.hand_item:
		if Globals.player.hand_item.tool_type == "hoe":
			if self.get_cellv(tile_pos_infront_of_player) == CONSTANTS.DIRT_ID:
				if MouseGrid.can == false:
					MouseGrid.can = true
					MouseGrid.texture("24")
			else:
				if MouseGrid.can == true:
					MouseGrid.can = false
					MouseGrid.texture("24")
	else:
		if self.get_cellv(tile_pos_infront_of_player) == CONSTANTS.SCRATCH_DIRT_ID:
			if MouseGrid.can == false:
				MouseGrid.can = true
				MouseGrid.texture("24")
		else:
			if MouseGrid.can == true:
				MouseGrid.can = false
				MouseGrid.texture("24")

func refresh_tiles():
	var wet_dirts = get_used_cells_by_id(CONSTANTS.WET_DIRT_ID)
	for tile_pos in wet_dirts:
		set_cellv(tile_pos, get_tileset().find_tile_by_name(CONSTANTS.SCRATCH_DIRT_NAME))

func plant_crop(crop_path):
	if self.get_cellv(tile_pos_infront_of_player) == CONSTANTS.SCRATCH_DIRT_ID:
		var crop = load(crop_path).instance()
		crop.initialize(crop.crop_data)
		crop.global_position = tile_pos_infront_of_player * 24
		add_child(crop)
		self.set_cellv(tile_pos_infront_of_player, self.get_tileset().find_tile_by_name(CONSTANTS.USED_DIRT_NAME))

func hoe_dirt():
	if self.get_cellv(tile_pos_infront_of_player) == CONSTANTS.DIRT_ID:
		self.set_cellv(tile_pos_infront_of_player, self.get_tileset().find_tile_by_name(CONSTANTS.SCRATCH_DIRT_NAME))

func can_plant():
	if self.get_cellv(tile_pos_infront_of_player) == CONSTANTS.SCRATCH_DIRT_ID:
		return true
	return false

func clear_dirt(pos):
	var tile_position = world_to_map(pos)
	if self.get_cellv(tile_position) == CONSTANTS.USED_DIRT_ID:
		self.set_cellv(tile_position, self.get_tileset().find_tile_by_name(CONSTANTS.DIRT_NAME))
