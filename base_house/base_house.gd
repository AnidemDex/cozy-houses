extends Node

export(Color) var grid_color := Color.red
export(NodePath) var house_path:NodePath
export(NodePath) var player_path:NodePath

var on_edit_mode := false

onready var house:TileMap = get_node(house_path)
onready var player:Node2D = get_node(player_path)

func _ready() -> void:
	$Background.color = Color("#863253")
	$EditTool.set("house_tilemap", house)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("edit_mode"):
		on_edit_mode = !on_edit_mode
		$EditTool.visible = on_edit_mode


func _on_EditTool_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$EditTool.update()

