extends Control

export(Color) var grid_color = Color.cyan

var house_tilemap:TileMap

func _ready() -> void:
	hide()

func _draw() -> void:
	_draw_grid()
	
	var drag_data:Furniture = get_tree().root.gui_get_drag_data() as Furniture
	if drag_data != null:
		_draw_furniture_hint(drag_data)
	
	var map_position = get_mouse_map_position()
	if house_tilemap.get_cellv(map_position) != -1:
		
		var rect_hint:Rect2 = Rect2(map_position*house_tilemap.cell_size, house_tilemap.cell_size)
		var color_hint = Color.blue
		color_hint.a = 0.5
		draw_rect(rect_hint, color_hint)


func _gui_input(event: InputEvent) -> void:
	if event.is_action_released("remove_item"):
		var mouse_map = get_mouse_map_position()
		house_tilemap.set_cellv(mouse_map, -1)
			
		accept_event()
	
	if event.is_action_released("add_item"):
		var mouse_map = get_mouse_map_position()
		var cell = house_tilemap.get_cellv(mouse_map)
		# tile selected stuff
		accept_event()

func _draw_grid() -> void:
	var min_grid_size:Vector2 = house_tilemap.cell_size
	var columns = int(rect_size.x/min_grid_size.x)
	var rows = int(rect_size.y/min_grid_size.y)
	
	for x in columns:
		var from = Vector2(x*min_grid_size.x, 0)
		var to = Vector2(x*min_grid_size.x, rect_size.y)
		draw_line(from, to, grid_color)
	
	for y in rows:
		var from = Vector2(0, y*min_grid_size.y)
		var to = Vector2(rect_size.x, y*min_grid_size.y)
		draw_line(from, to, grid_color)


func _draw_furniture_hint(drag_data:Furniture) -> void:
	var map_position = get_mouse_map_position()
	var rect_hint = house_tilemap.tile_set.tile_get_region(drag_data.ID)
	var hint_color = Color.white.darkened(0.4)
	
	if not can_place(drag_data):
		hint_color = Color.red
	
	hint_color.a = 0.4
	rect_hint.position = map_position*house_tilemap.cell_size
	
	draw_texture_rect_region(house_tilemap.tile_set.tile_get_texture(drag_data.ID), rect_hint, house_tilemap.tile_set.tile_get_region(drag_data.ID), hint_color)
	draw_rect(rect_hint, Color.red, false)
	
	var used_cells = house_tilemap.get_used_cells()
	for cell_map_pos in used_cells:
		var cell = house_tilemap.get_cellv(cell_map_pos)
		if cell == -1:
			continue
		
		var cell_rect:Rect2 = house_tilemap.tile_set.tile_get_region(cell)
		cell_rect.position = cell_map_pos*house_tilemap.cell_size
		draw_rect(cell_rect, drag_data.main_color, false, 1.2)


func can_drop_data(_position: Vector2, data) -> bool:
	if not(data is Furniture):
		return false
	data = data as Furniture
	var can_drop := can_place(data)
	return can_drop


func drop_data(_position: Vector2, data) -> void:
	var map_mouse_position = get_mouse_map_position()
	house_tilemap.set_cellv(map_mouse_position, data.ID)


func get_mouse_map_position() -> Vector2:
	var map_mouse_position:Vector2 = house_tilemap.world_to_map(house_tilemap.get_local_mouse_position())
	return map_mouse_position


func can_place(furniture:Furniture) -> bool:
	var tile_set:TileSet = house_tilemap.tile_set
	var map_mouse_position:Vector2 = get_mouse_map_position()
	
	var tile_rect:Rect2 = house_tilemap.tile_set.tile_get_region(furniture.ID)
	var fixed_tile_rect:Rect2 = tile_rect
	fixed_tile_rect.position = map_mouse_position*house_tilemap.cell_size
	var used_cells:Array = house_tilemap.get_used_cells()
	
	
	for cell_map_pos in used_cells:
		var cell = house_tilemap.get_cellv(cell_map_pos)
		if cell == -1:
			continue
		
		var cell_rect:Rect2 = tile_set.tile_get_region(cell)
#		cell_rect.position = (cell_rect.position / house_tilemap.cell_size)
		cell_rect.position = cell_map_pos*house_tilemap.cell_size
#		cell_rect.size = (cell_rect.size / house_tilemap.cell_size)
#		cell_rect.position += cell_map_pos
		
		
		if cell_rect.has_point(map_mouse_position):
			return false
		
		
		if fixed_tile_rect.intersects(cell_rect):
			return false
	
	return true



