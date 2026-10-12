@abstract class_name Gate extends Node2D
var explosionscene =  preload("res://doodads/explosion.tscn");
var calcs = 0
const MAX_UPDATES_PER_FRAME = 10
var exploded  =false
var outputs ={}
var beingDragged = false

func _ready() -> void:
	for term in get_children():
		if term is WireTerminal:
			term.changed.connect(_input_changed)
	if $draggable != null:
		$draggable.input_event.connect(_on_draggable_input_event)
	calculate()
	
func _process(_delta: float) -> void:
	calcs = 0

func input(nname:String):
	var node =get_node(nname)
	if node != null and is_instance_of(node, WireTerminal):
		return node.value
	else:
		return 0
			
func output(nname:String, val:int, defer =false):
	var node =get_node(nname)
	if node != null and is_instance_of(node, WireTerminal):
		outputs[node] = val
	else:
		print("Err,terminal not found, ", name)
	if !defer:
		node.input_changed()
	else:
		if !get_tree().process_frame.is_connected(node.input_changed):
			get_tree().process_frame.connect(node.input_changed,ConnectFlags.CONNECT_ONE_SHOT)

@abstract func calculate()

func _input_changed():
	if not exploded and calcs < MAX_UPDATES_PER_FRAME:
		calcs +=1
		outputs= {}
		calculate()
	
	elif calcs >=  MAX_UPDATES_PER_FRAME:
		_explode()


func _explode():
	print("splode!")
	var explosionsprite:Sprite2D = explosionscene.instantiate()
	add_child(explosionsprite)
	exploded = true
	

func _on_draggable_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event.is_action_pressed("primaryClick"):
		beingDragged = true
	elif beingDragged and event.is_action_released("primaryClick"):
		beingDragged = false
	
func _input(event: InputEvent) -> void:
	if beingDragged and event is InputEventMouseMotion:
		self.global_position = event.position
		for child in get_children():
			if child is WireTerminal and child.wire!=null:
				child.wire.render()
