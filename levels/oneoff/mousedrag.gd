extends Node2D
@export var start = Vector2(209,163)
@export var end = Vector2(424.0,253)
@export var traveltime:float = 2
@export var start_pause:float = 1
@export var end_pause:float = .5
@export var term1:WireTerminal
@export var term2:WireTerminal
@export var next:Node2D
var curtime = 0.0

func _ready() -> void:
	$CPUParticles2D.emitting = true

func _process(delta: float) -> void:

	curtime +=delta
	var t = min(1,max(0, curtime - start_pause)/ traveltime)
	position = start+(end-start)*t
	if curtime > traveltime+start_pause+end_pause:
		curtime = 0
		position = start
		$CPUParticles2D.emitting = true

func _edited():
	if term1.wire!=null:
		visible = false
		next.awaken()
	else:
		visible = true
		next.visible = false
		curtime= 0
