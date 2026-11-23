extends Gate
var lasta = 0;
var switchstable = 0
func diode(inn,out):
	var v = input(inn)
	#outputs[get_node(inn)] = 0;
	output(out,v)
func _process(_delta: float) -> void:
	super(_delta)
	switchstable = false

func calculate():
	if ! switchstable:
		get_node("in").changed.emit()
		switchstable = true
		return
	var a  = input("in")
	if a == 0:
		$arrows.rotation = PI
		diode("top1","bot1")
		diode("top2","bot2")

	elif a ==1:
		$arrows.rotation = 0
		diode("bot1","top1")
		diode("bot2","top2")
		
	elif a ==-1:
		$arrows.rotation = PI/2
		diode("top1","top2")
		diode("bot1","bot2")
	if lasta!= a:
		lasta = a
		for node in get_children():
			if node is WireTerminal and node.name!="in":
				node.input_changed()
		
