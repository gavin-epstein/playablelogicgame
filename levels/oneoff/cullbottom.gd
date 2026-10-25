extends RigidBody2D


func _process(_delta: float) -> void:
	if position.y > get_viewport_rect().size.y:
		queue_free()
