@abstract class_name Gate extends Doodad
const explosionscene =  preload("res://doodads/explosion.tscn");
var calcs = 0
const MAX_UPDATES_PER_FRAME = 64
var exploded  =false
var outputs ={}
var beingDragged = false
var explosionsprite:Sprite2D
var spawned = false
var was_exploded = false

func _ready() -> void:
	for term in get_children():
		if term is WireTerminal:
			term.changed.connect(input_changed)
	if find_child("draggable", false) != null:
		$draggable.input_event.connect(_on_draggable_input_event)
	if get_parent() is Level:
		get_parent().edited.connect(self._unexplode)
	calculate()
	
func _process(_delta: float) -> void:
	calcs = 0
	was_exploded = exploded
func input(nname:String):
	var node =get_node(nname)
	if node != null and is_instance_of(node, WireTerminal):
		return node.value
	else:
		return 0
			
func output(nname:String, val:int):
	var oldval = -2
	var node =get_node(nname)
	if node != null and is_instance_of(node, WireTerminal):
		if node in outputs.keys():
			oldval = outputs[node]
		if oldval!=val:
			outputs[node] = val
			node.input_changed()
	else:
		print("Err,terminal not found, ", nname, " in ", name)
	
	#else:
		#if !get_tree().process_frame.is_connected(node.input_changed):
			#get_tree().process_frame.connect(node.input_changed,ConnectFlags.CONNECT_ONE_SHOT)

@abstract func calculate()

func input_changed():
	if get_parent() is Level:
		get_parent().add_to_update_queue(self)
	else:
		print("Level not found by " + name)
func process_from_queue():
	if not exploded and calcs < MAX_UPDATES_PER_FRAME:
		calcs +=1
		outputs= {}
		calculate()
	
	elif calcs >=  MAX_UPDATES_PER_FRAME:
		_explode()


func _explode():

	if not exploded:
		explosionsprite = explosionscene.instantiate()
		if was_exploded:
			explosionsprite.silent = true
		add_child(explosionsprite)
	exploded = true
	
func _unexplode():
	if exploded:
		exploded = false
		explosionsprite.queue_free()
		
	calculate()
func _on_draggable_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event.is_action_pressed("primaryClick"):
		beingDragged = true
		get_viewport().set_input_as_handled()
	elif beingDragged and event.is_action_released("primaryClick"):
		beingDragged = false
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = event.position
		query.collide_with_areas = true
		var result = space_state.intersect_point(query)
		for res in result:
			var area =   res.collider.get_parent()
			if area is GateArea:
				area.onDropped(self)
	
func _input(event: InputEvent) -> void:
	if !Engine.is_editor_hint() and beingDragged and event is InputEventMouseMotion:
		self.global_position = event.position
		for child in get_children():
			if child is WireTerminal and child.wire!=null:
				child.wire.render()

func save()->Dictionary:
	var d = {}
	d["xpos"] = position.x
	d["ypos"] = position.y
	d["xscale"] = scale.x
	d["yscale"] = scale.y
	d["spawned"] = spawned
	d["resource"] = get_scene_file_path()
	d["path"] = get_path()
	d["lockedterms"] = []
	d["name"]=name
	#for child in get_children():
		#if child is WireTerminal and child.locked:
			#d["lockedterms"].append(child.name)
	return d

func load_from_save(d:Dictionary):
	position.x = d["xpos"] 
	position.y = d["ypos"] 
	scale.x = d["xscale"]  
	scale.y = d["yscale"] 
	spawned = d["spawned"]
	name = d["name"]
	
	#for childname in d["lockedterms"]:
	#	get_child(childname).lock()
