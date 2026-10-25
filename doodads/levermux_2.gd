class_name Levermux2 extends Lever

func _ready() -> void:
	super._ready()
	$Lever.toggled.connect(_on_lever_toggled)
	if $Lever.button_pressed:
		state = 0
	else:
		state = 1

func set_state(s:int):
	state = s
	if state == 0:
		$Lever.button_pressed = true
	elif state == 1:
		$Lever.button_pressed = false
	calculate()


func calculate():
	if $Lever.button_pressed:
		output("2",input("1"))
		
	else:
		output("2",input("0"))

func _on_lever_toggled(toggled_on: bool) -> void:
	if toggled_on:
		state = 0
	else:
		state = 1
	$AudioStreamPlayer.play_randomized()
	calculate()
	statechanged.emit()
