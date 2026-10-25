extends Node2D

@export var lever:TextureButton
@export var menu:Control
func _ready() -> void:
	lever.pressed.connect(die)

func awaken():
	self.visible = true
	$Timer.start()

	
func click():
	if self.visible:
		$CPUParticles2D.emitting = true
		

func die():
	if self.visible:
		menu.visible = true
		self.visible = false
		
