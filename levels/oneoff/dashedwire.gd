extends Panel

@onready var icon = get_node("../..")

func _process(delta: float) -> void:
	var span = icon.position-icon.start
	self.position = -1*span
	size.x = span.length()/scale.x
	rotation = span.angle()
