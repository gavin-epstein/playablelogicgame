extends Gate

var connectedterms = []
var virtualWire:VirtualWire

func _ready() -> void:
	super._ready()
	if get_parent() is Level:
		get_parent().edited.connect(reconfigure)
	virtualWire = VirtualWire.new()
	reconfigure()
	

func calculate():
	var val = 0
	if virtualWire !=null:
		virtualWire.input_changed()
		val = virtualWire.value
	
	#for _i in range(6):
		#var term:WireTerminal = get_node(str(_i))
		#if term.wire!=null:
			#var other = term.wire.get_other_end(term)
			#if other!= null and other.get_parent() != self:
				#val += other.get_value()
	#val = clampi(val, -1, 1)
	for _i in range(6):
		output(str(_i),val)
	#for node:WireTerminal in connectedterms:
		#var supress =  node in node.get_parent().outputs.keys()
		#node.set_value(val, supress)

func reconfigure():
	if virtualWire!= null:
		virtualWire.delete_wire()
	virtualWire= VirtualWire.new()
	for term:WireTerminal in connectedterms:
		
		term.input_changed()
	connectedterms = []
	for _i in range(6):
		var term:WireTerminal = get_node(str(_i))
		if term.visualWire!=null:
			term.visualWire.visual_only = true
			term.visualWire.modulate = Color(0,.5,0) #debug only
			var other:WireTerminal = term.visualWire.get_other_end(term)
			if other != null:
				connectedterms.append(other)
				other.connect_wire(virtualWire, "terminals")
	calculate()
