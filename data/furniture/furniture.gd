tool
extends Resource
class_name Furniture

export(String) var name:String = "None"
export(String) var category:String = "Test"
export(Color) var main_color := Color.black
export(Color) var secondary_color := Color.black

var icon:Texture setget ,get_icon
var ID:int = -1

func get_icon() -> Texture:
	var tileset:TileSet = load("res://furniture_tileset.tres")
	if tileset == null:
		return null
	if ID == -1:
		return null
	if ID > tileset.get_tiles_ids().size():
		return null
	var tile_texture:Texture = tileset.tile_get_texture(ID)
	var texture := ImageTexture.new()
	texture.create_from_image(tile_texture.get_data().get_rect(tileset.tile_get_region(ID)))
	return texture
	

func _get_property_list() -> Array:
	var tileset:TileSet = load("res://furniture_tileset.tres")
	var p := []
	var hint_string := "[NONE]:-1,"
	for tile_id in tileset.get_tiles_ids():
		var tile_name:String = tileset.tile_get_name(tile_id)
		if not tile_name.begins_with("f_"):
			continue
		hint_string += "%s-%s:%s,"%[tile_id, tileset.tile_get_name(tile_id), tile_id]
	hint_string = hint_string.trim_suffix(",")
	p.append({"type":TYPE_INT, "name":"ID", "usage":PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE, "hint":PROPERTY_HINT_ENUM, "hint_string":hint_string})
	return p
