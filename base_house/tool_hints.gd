extends Control

func _ready() -> void:
	for child in get_children():
		child = child as Control
		if child == null: continue
		child.connect("mouse_entered", self, "_on_child_mouse_entered", [child])
		child.connect("mouse_exited", self, "_on_child_mouse_exited", [child])
	
	$LMBHint.hide()


func _on_drag_begin() -> void:
	$LMBHint.show()

func _on_drag_end() -> void:
	$LMBHint.hide()


func _on_child_mouse_entered(child:Control) -> void:
	child.modulate.a = 0.4

func _on_child_mouse_exited(child:Control) -> void:
	child.modulate.a = 1

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_BEGIN:
			_on_drag_begin()
		NOTIFICATION_DRAG_END:
			_on_drag_end()
