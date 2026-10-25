extends RichTextLabel
var beingDragged = false



func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("primaryClick"):
		beingDragged = true
		get_viewport().set_input_as_handled()
	elif beingDragged and event.is_action_released("primaryClick"):
		beingDragged = false

func _input(event: InputEvent) -> void:
	if beingDragged and event is InputEventMouseMotion:
		if get_viewport_rect().has_point(event.position):
			self.global_position = event.position-Vector2(.5,.25)*size*self.scale
