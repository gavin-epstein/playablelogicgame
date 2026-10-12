@tool
class_name Wire extends Node2D
var value = 0
var visual_only = false
		
@export var term1:WireTerminal:
	set(term):
		if Engine.is_editor_hint() and term1!=null:
			term1.locked = false
			term1.wire = null
		term1 = term
		if Engine.is_editor_hint() :
			connect_wire_editor(term)
@export var term2:WireTerminal:
	set(term):
		if Engine.is_editor_hint() and term2!=null:
			term2.locked = false
			term2.wire = null
		term2=term
		if Engine.is_editor_hint():
			connect_wire_editor(term)
		render()
const MAX_UPDATES_PER_FRAME = 5
var explosionscene =  preload("res://doodads/explosion.tscn");
var calcs = 0
var exploded  =false

func connect_wire_editor(term):
	if term == null:
		return
	if term.wire != null:
		term.wire.delete_wire()
	term.changed.connect(input_changed)
	term.wire = self
	term.locked = true	

func set_value(val):
	if !exploded and calcs < MAX_UPDATES_PER_FRAME and not Engine.is_editor_hint(): 
		if val!=value:
			calcs+=1
			value = val
			if val == 0:
				$Wire0.visible = true
				$Wire1.visible = false
				$"Wire-1".visible = false
			elif val ==1:
				$Wire0.visible = false
				$Wire1.visible = true
				$"Wire-1".visible = false
			elif val == -1:
				$Wire0.visible = false
				$Wire1.visible = false
				$"Wire-1".visible = true
		if not visual_only:
			term1.set_value(value)
			if term2 !=null:
				term2.set_value(value)
	elif !exploded and calcs > MAX_UPDATES_PER_FRAME:
		explode()
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		calcs = 0
		if term1 == null:
			delete_wire()
		elif term2 ==null:
			render()
func _ready() -> void:
	if term1 !=null and term2!=null and not Engine.is_editor_hint():
		input_changed()
		term1.wire = self
		term2.wire = self
		term1.changed.connect(input_changed)
		term2.changed.connect(input_changed)
func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	if term2 == null:
		if event is InputEventMouseButton and event.is_action_released("primaryClick"):
			var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
			var query = PhysicsPointQueryParameters2D.new()
			query.position = event.position
			query.collide_with_areas = true
			var result = space_state.intersect_point(query)
			if len(result) != 1:
				delete_wire()
			else:
				var area:Area2D = result[0].collider
				var term = area.get_parent()
				if  term is WireTerminal and !term.locked:
					if term == term1:
						delete_wire()
					else:
						term.connect_wire(self,"term2")
						input_changed()
						render()
						get_parent().edited.emit()
func render():
	if Engine.is_editor_hint() and term1 ==null:
		return
	var t1 = term1.global_position
	var t2
	if term2 != null:
		t2 = term2.global_position
	else:
		t2 = get_viewport().get_mouse_position()
	self.global_position = .5*(t1+t2)
	self.global_scale.x = (t1-t2).length()/1000
	self.global_rotation = (t1-t2).angle()

func input_changed():
		var val = 0
		if term1!=null:
			val+= term1.get_value()
		if term2!= null:
			val+=term2.get_value()
		set_value(clampi(val,-1,1))

func explode():
	var explosionsprite:Sprite2D = explosionscene.instantiate()
	add_child(explosionsprite)
	exploded = true

func delete_wire():
	exploded = true
	if term1!=null:
		term1.wire = null
		term1.input_changed()
	if term2!=null:
		term2.wire = null
		term2.input_changed()
		get_parent().edited.emit()
	queue_free()
	
func get_other_end(term:WireTerminal)->WireTerminal:
	if term == term1:
		return term2
	elif term == term2:
		return term1
	else:
		print("get_other end invalid")
		return null
