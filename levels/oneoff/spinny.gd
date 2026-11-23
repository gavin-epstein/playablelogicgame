extends TextureRect

@export var rotation_time:float = 360. #s.rotation

func _process(delta: float) -> void:
	self.rotation += delta*PI*2/rotation_time
