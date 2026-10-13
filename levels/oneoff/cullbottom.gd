extends RigidBody2D


func _process(delta: float) -> void:
	if position.y > get_viewport_rect().size.y:
		queue_free()
