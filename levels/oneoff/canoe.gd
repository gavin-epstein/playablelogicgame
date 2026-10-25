extends TextureRect

@export var start = Vector2(1728,-210)
@export var end = Vector2(-816.0,718)
@export var traveltime:float = 2
@export var start_pause:float = 1
var curtime = 0.0

func _process(delta: float) -> void:

	curtime +=delta
	var t = max(0, curtime - start_pause)/ traveltime
	position = start+(end-start)*t + sin(30*t)*Vector2(0,5)+sin(2*t)*Vector2(5,30)
	if curtime > traveltime+start_pause:
		curtime = 0
		position = start
