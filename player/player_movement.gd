extends KinematicBody2D

export(float) var speed := 10.0

func _physics_process(_delta: float) -> void:
	var movement := get_movement_vector().normalized()
	movement = movement*speed
	var _collision = move_and_collide(movement)


func get_movement_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
