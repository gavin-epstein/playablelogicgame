class_name Levermux3 extends Lever
const sewi  = preload("res://doodads/images/levermux2on.png")
const anpa = preload("res://doodads/images/levermux2off.png")
const lon = preload("res://doodads/images/levermux3lon.png")


func _ready() -> void:
	super._ready()
	$Lever.pressed.connect(_on_lever_pressed)
	set_state(state)

func calculate():
	if state ==1:
		output("out",input("top"))
	elif state == 0:
		output("out",input("mid"))
	elif state == -1:
		output("out",input("bot"))



func set_state(s:int):
	state = s
	if state == 1:
		$Lever.texture_normal=sewi
		$Lever.texture_pressed = lon
	elif state == 0:
		$Lever.texture_normal=lon
		$Lever.texture_pressed = anpa
	elif state == -1:
		$Lever.texture_normal=anpa
		$Lever.texture_pressed = sewi
	calculate()
	statechanged.emit()

func  _on_lever_pressed():
	if state == 1:
		set_state(0)
	elif  state ==  -1:
		set_state(1)
	elif  state == 0:
		set_state(-1)
	
	
