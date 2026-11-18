extends Node2D
var goal = -850
var speed = 2 #tiles per second
var term:WireTerminal 
func _ready() -> void:
	go_to_position(0)
	term= get_parent().get_node("out")

func go_to_position(i):
	if  i ==0:
		self.position.y = -850
		goal = -850
		$CPUParticles2D.emitting = false
	elif i <= get_parent().length:
		goal = 850 *(i-1)
	else:
		goal = 850 * (i+1)

func _process(delta: float) -> void:
	if self.position.y < goal:
		self.position.y += delta*850*speed
	if self.position.y > 850*get_parent().length:
		go_to_position(0)
	term.position.y = self.position.y
	if term.wire != null:
		term.wire.render()
	
