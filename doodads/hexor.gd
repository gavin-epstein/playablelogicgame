class_name MultiOr extends Gate

var connectedterms = []
var connectedOrs =[]
var sup:MultiOr

func _ready() -> void:
	super()
	if get_parent() is Level:
		get_parent().edited.connect(reconfigure)
	reconfigure()
	calculate()
	
func _process(_delta: float) -> void:
	super(_delta)
	calculate()
func calculate():
	#if sup!=null:
		#self.modulate = Color(1.0, 0.0, 0.0, 1.0)
	#else:
		#self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	var val =0
	for gate:MultiOr in connectedOrs:
		var otherval  = gate.calculate()
		if otherval == null:
			print(gate.isSub, gate.connectedOrs)
		val += otherval
	for term:WireTerminal in connectedterms:
		if not term.get_parent() is MultiOr:
			val+=term.get_value()
	if sup!=null:
		return val
	
	val = clampi(val, -1, 1)
	set_recursive(val)
func set_recursive(val:int):
	for _i in range(6):
		output(str(_i),val)
	for gate:MultiOr in connectedOrs:
		gate.set_recursive(val)
	for node:WireTerminal in connectedterms:
		if node.wire!=null:
			node.wire.set_value(val)
		var supress =  node in node.get_parent().outputs.keys()
		#if supress:
			#node.modulate = Color(0,1,0)
		#else:
			#node.modulate = Color(1,1,1)
		node.set_value(val, supress)
	
func reconfigure():
	connectedOrs = []
	if sup!= null and self not in sup.connectedOrs:
		sup = null
	for _i in range(6):
		var term:WireTerminal = get_node(str(_i))
		if term.wire!=null:
			term.wire.visual_only = true
			#term.wire.modulate = Color(0,.5,0) #debug only
			var other:WireTerminal = term.wire.get_other_end(term)
			if other != null:
				var othergate:Gate = other.get_parent()
				if othergate is MultiOr:
					var supsup = othergate
					while supsup.sup !=null and supsup.sup!=self:
						supsup=supsup.sup
					if self.name < supsup.name:
						supsup.sup = self
						connectedOrs.append(supsup)
					#for orgate:MultiOr in other.connectedOrs:
						#connectedOrs.append(orgate)
						#orgate.sup = self
					#othergate.connectedOrs = []
	for term:WireTerminal in connectedterms:
		term.changed.disconnect(input_changed)
		#term.input_changed()
	var oldconnected = connectedterms
	connectedterms = []
	for _i in range(6):
		var term:WireTerminal = get_node(str(_i))
		if term.wire!=null:
			var other:WireTerminal = term.wire.get_other_end(term)
			if other != null:
				var othergate:Gate = other.get_parent()
				if not othergate is MultiOr:
					connectedterms.append(other)
					other.changed.connect(input_changed)
	calculate()
	for term:WireTerminal in oldconnected:
		if term not in connectedterms:
			term.input_changed()

func _explode():
	super._explode()
	for term:WireTerminal in connectedterms:
		term.get_parent()._explode()
		
