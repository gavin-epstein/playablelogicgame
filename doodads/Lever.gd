@abstract class_name Lever extends Gate
@export var nimi:String
var state=1
@warning_ignore("unused_signal") signal statechanged 

func _ready() -> void:
	super._ready()
	$Label.text = "[center]"+nimi+"[/center]"

@abstract func set_state(s:int)
