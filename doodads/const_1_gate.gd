extends Gate
@export var val=1

func _ready() -> void:
	super._ready()
	calculate()



func calculate():
	
	output("0",val)
	output("1",val)
	output("2",val)
