extends Node3D
const speed = .01

func _process(delta: float) -> void:
	rotate(Vector3.UP, speed*delta)
	get_child(0).rotate(Vector3.UP, speed*delta/PI)
