extends RichTextLabel
@export var speed = .0001
@export var amount  = 960/5.0
@export var center = 228.0
func _process(_delta: float) -> void:
	position.x = amount*sin(speed*Time.get_ticks_msec())+center
