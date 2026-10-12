@tool
class_name WireTerminal extends Node2D
var wireScene = preload("res://doodads/Wire.tscn")
var screwScene = preload("res://doodads/screw.tscn")


var value =0;
var wire:Wire;
@export var locked:bool = false:
	set(val):
		locked = val

signal changed

func _ready() -> void:
	if locked and not Engine.is_editor_hint():
		var newscrew:Node2D= screwScene.instantiate()
		add_child(newscrew)
		newscrew.global_rotation = (randf()-.5)*PI/3.


func get_value():
	if self in get_parent().outputs:
		return get_parent().outputs[self]
	return 0
func set_value(val):
	if  val !=  value:
		value = val
		if value == 0:
			$"0".visible = true
			$"1".visible = false
			$"-1".visible = false
		elif value ==1:
			$"0".visible = false
			$"1".visible = true
			$"-1".visible = false
		elif value == -1:
			$"0".visible = false
			$"1".visible = false
			$"-1".visible = true
		if not Engine.is_editor_hint():
			emit_signal("changed")

func connect_wire(newWire:Wire, param = "term1"):
	if wire != null:
		wire.delete_wire()
	changed.connect(newWire.input_changed)
	newWire[param] = self
	self.wire = newWire
	if not Engine.is_editor_hint():
		newWire.input_changed()
	else:
		print("locking")
		locked = true
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("primaryClick") and !locked:
		if wire!=null:
			wire.delete_wire()
		var newWire:Wire = wireScene.instantiate()
		get_node("../..").add_child(newWire)
		connect_wire(newWire)
		
	elif event.is_action_pressed("secondaryClick"):
		if wire!=null:
			wire.queue_free()
func input_changed():
	if not Engine.is_editor_hint():
		if wire!=null:
			wire.input_changed()
			if wire.visual_only:
				set_value(get_value())
		else:
			set_value(get_value())
