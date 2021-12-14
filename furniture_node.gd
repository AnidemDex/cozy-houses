extends PanelContainer
class_name FurnitureNode

var text:String = "" setget set_text
var icon:Texture setget set_icon
var furniture:Furniture
var can_force_drag := false

var _label:Label
var _icon:TextureButton
var _vb:VBoxContainer

func _enter_tree() -> void:
	set("text", furniture.name)
	set("icon", furniture.icon)


func _init() -> void:
	add_constant_override("separation", 0)
	_vb = VBoxContainer.new()
	_label = Label.new()
	_icon = TextureButton.new()
	_icon.toggle_mode = true
	_icon.size_flags_vertical = SIZE_EXPAND_FILL
	_icon.expand = true
	_icon.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
	_icon.rect_min_size = Vector2(12,12)
	
	
	_icon.connect("draw", self, "_on_icon_draw")
	_icon.connect("toggled", self, "_on_icon_toggled")
	_icon.set_drag_forwarding(self)
	
	_vb.add_child(_label)
	_vb.add_child(_icon)
	add_child(_vb)
	

func set_text(value:String) -> void:
	text = value
	_label.text = value


func set_icon(value:Texture) -> void:
	icon = value
	_icon.texture_normal = value


func _on_icon_draw() -> void:
	match _icon.get_draw_mode():
		TextureButton.DRAW_HOVER:
			_icon.modulate = Color.white.darkened(0.4)
		TextureButton.DRAW_PRESSED:
			var col = furniture.secondary_color
			_icon.modulate = Color(col.r, col.g, col.b, 0.8) 
		TextureButton.DRAW_NORMAL:
			_icon.modulate = Color.white


func _on_icon_toggled(toggled:bool) -> void:
	if toggled:
		call_deferred("force_drag", furniture, _icon.duplicate())


func get_drag_data_fw(position: Vector2, fw_control:Control):
	var preview_node = _icon.duplicate()
	set_drag_preview(preview_node)
	return furniture


func set_group(group:ButtonGroup) -> void:
	_icon.group = group
