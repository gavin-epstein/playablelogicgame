extends Button
var xscene = preload("res://levels/oneoff/x.tscn")



func _on_pressed() -> void:
	var x:RigidBody2D  = xscene.instantiate()
	add_child(x)
	x.position = Vector2(130,0)
	x.apply_central_force(10000*Vector2(randf_range(-1,1),randf_range(-1,-3)))
