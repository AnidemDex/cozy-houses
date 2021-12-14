tool
extends TileSet

export(Dictionary) var _furniture_list:Dictionary = {}

func _init() -> void:
	_furniture_list = {}
	if not is_connected("changed", self, "_on_change"):
		connect("changed", self, "_on_change", [], CONNECT_DEFERRED)

func get_all_furniture() -> void:
	pass


func _on_change() -> void:
	var _Furniture = load("res://data/furniture/furniture.gd")
	_furniture_list = {}
	for tile_id in get_tiles_ids():
		var tile_name:String = tile_get_name(tile_id)
		if not tile_name.begins_with("f_"):
			continue
		tile_name = tile_name.replace("f_","")
		var furniture_folder_path := "res://data/furniture/"
		var furniture_path := furniture_folder_path+tile_name+".tres"
		var furniture
		
		if ResourceLoader.exists(furniture_path):
			var _f = ResourceLoader.load(furniture_folder_path+tile_name+".tres", "Resource", true)
			furniture = _f
		
		if furniture == null:
			furniture = _Furniture.new()
		
		furniture.name = tile_name.capitalize()
		furniture.ID = tile_id
		
		var _err = ResourceSaver.save(furniture_folder_path+tile_name+".tres", furniture)
		assert(_err == OK)
		_furniture_list[tile_id] = furniture
