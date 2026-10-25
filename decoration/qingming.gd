extends Sprite2D
const width = 12805.0
@export var scroll_time = 600.0 #second

func _process(delta: float) -> void:
	position.x+= delta * (width/scroll_time)
	if position.x > width/2 +960:
		position.x -= (width+960)
