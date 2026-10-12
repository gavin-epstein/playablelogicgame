extends Gate

var connectedterms = []

func _ready() -> void:
	super._ready()
	if get_parent() is Level:
		get_parent().edited.connect(reconfigure)
	reconfigure()

func calculate():
	var val = 0
	for _i in range(6):
		var term:WireTerminal = get_node(str(_i))
		if term.wire!=null:
			var other = term.wire.get_other_end(term)
			if other!= null and other.get_parent() != self:
				val += other.get_value()
	val = clampi(val, -1, 1)
	for _i in range(6):
		output(str(_i),val)
	for node:WireTerminal in connectedterms:
		node.set_value(val)
		
func reconfigure():
	for term:WireTerminal in connectedterms:
		term.changed.disconnect(self._input_changed)
		term.input_changed()
	connectedterms = []
	for _i in range(6):
		var term:WireTerminal = get_node(str(_i))
		if term.wire!=null:
			term.wire.visual_only = true
			term.wire.modulate = Color(0,.5,0) #debug only
			var other:WireTerminal = term.wire.get_other_end(term)
			if other != null:
				connectedterms.append(other)
			
				other.changed.connect(self._input_changed)
	calculate()
