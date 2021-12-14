extends TabContainer

const UnlockedFurniture = preload("res://data/unlocked_furniture.gd")

var unlocked_furniture:UnlockedFurniture = load("res://data/unlocked_furniture.tres")

# Hold your breath because after this jam, neither God
# or me is going to understand what is happening here
class Category extends PanelContainer:
	var scroll_ctn:ScrollContainer
	var list_node:WrappContainer
	var button_group:ButtonGroup
		
	func _enter_tree() -> void:
		scroll_ctn = ScrollContainer.new()
		scroll_ctn.size_flags_horizontal = SIZE_EXPAND_FILL
		scroll_ctn.size_flags_vertical = SIZE_EXPAND_FILL
		list_node = WrappContainer.new()
		list_node.size_flags_horizontal = SIZE_EXPAND_FILL
		list_node.size_flags_vertical = SIZE_EXPAND_FILL
		list_node.add_constant_override("hseparation", get_constant("separation", "HBoxContainer"))
		list_node.add_constant_override("vseparation", get_constant("separation", "VBoxContainer"))
		scroll_ctn.add_child(list_node)
		add_child(scroll_ctn)
	
	func set_force_drag(value:bool) -> void:
		for child in get_children():
			child.set("can_force_drag", value)
	
	
	func add_furniture(furniture:Furniture) -> void:
		var furn:FurnitureNode = FurnitureNode.new()
		furn.name = furniture.name
		furn.furniture = furniture
		furn.rect_min_size = Vector2(16,32)
		furn.set_group(button_group)
		list_node.add_child(furn)

var categories = {}
var furniture_group := ButtonGroup.new()

func _ready() -> void:
	for obj in unlocked_furniture.data:
		obj = obj as Furniture
		if obj == null:
			continue
		
		var category:Category
		
		if not obj.category in categories:
			add_category(obj.category)
		
		category = categories[obj.category]
		category.add_furniture(obj)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var _pressed_button = furniture_group.get_pressed_button()
		if is_instance_valid(_pressed_button):
			_pressed_button.pressed = false
			for category in categories:
				categories[category].set_force_drag(false)


func add_category(category_name:String) -> void:
	if category_name in categories:
		return
	
	var category := Category.new()
	category.name = category_name
	category.button_group = furniture_group
	categories[category_name] = category
	add_child(category)
