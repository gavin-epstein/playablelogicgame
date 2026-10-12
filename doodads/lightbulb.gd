class_name Lighbulb extends Gate
@export var nimi:String

func _ready() -> void:
	super._ready()
	$Label.text = "[center]"+nimi+"[/center]"

var value = 0
func setBulb():
	if value == 0:
		$Light0.visible = true
		$Light1.visible = false
		$Light2.visible = false
	elif value == -1:
		$Light0.visible = false
		$Light1.visible = false
		$Light2.visible = true
	elif value == 1:
		$Light0.visible = false
		$Light1.visible = true
		$Light2.visible = false
func calculate():
	var val = input("0")
	if val !=value:
		value =val
		setBulb()
	
