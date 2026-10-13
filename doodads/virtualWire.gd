@tool
class_name VirtualWire extends Wire
var terminals = []
var gates = []

func _get(property):
	if property == "term1" or property =="term2":
		assert(false, "virtual wire has no two terminals")
	return null
	
func _set(property, _val):
	if property == "term1" or property =="term2":
		assert(false, "virtual wire has no two terminals")
	return false

func connect_wire_editor(_term):
	print("no")

func set_value(val):
	if !exploded and calcs < MAX_UPDATES_PER_FRAME and not Engine.is_editor_hint(): 
		if val!=value:
			calcs+=1
			value = val
		for term in terminals:
			term.set_value(value)
	elif !exploded and calcs > MAX_UPDATES_PER_FRAME:
		explode()
		
func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		calcs = 0
		#if len(terminals)==0:
		#	delete_wire()
func _ready() -> void:
	pass

func _input(_event: InputEvent) -> void:
	pass

func render():
	pass

func input_changed():
		var val = 0
		for term:WireTerminal in terminals:
			val+= term.get_value()
		set_value(clampi(val,-1,1))
func explode():
	exploded = true
	for gate:Gate in gates:
		gate._explode()
	
func delete_wire():
	exploded = true
	for term:WireTerminal in terminals:
		term.wire = null
		term.input_changed()
	#get_parent().edited.emit()
	queue_free()
	
func get_other_end(term:WireTerminal)->WireTerminal:
	assert(false, "virtual wire has no two terminals")
	return null
