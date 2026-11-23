extends TextureRect
@export var dir = Vector2(1,0)
@export var width = 960
@export var height = 600
@export var scroll_time = 120.0 #second

func _process(delta: float) -> void:
	position+= dir* delta * (width/scroll_time)	
	if position.x > 960:
		position.x -= (width+960)
	if position.y > 600 and dir.y > 0:
		position.y -= (height+600)
	if position.y < -1*height and dir.y <0:
		position.y += (height*2)
