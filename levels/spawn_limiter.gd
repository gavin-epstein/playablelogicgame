class_name SpawnLimiter extends Node2D
var current = 0:
	set(new):
		current = new
		update_display()
@export var limit = 10:
	set(new):
		limit = new
		update_display()
func _ready() -> void:
	update_display()

static func toki_nanpa(nanpa:int):
	var out = ""
	if nanpa <0:
		nanpa*=-1
		out += "weka"
	while nanpa >20:
		out += "mute02"
		nanpa -= 20
	while nanpa > 5:
		out+="luka&"
		nanpa -=5
	if nanpa == 0:
		return "ala"
	elif nanpa ==1:
		out+= "wan"
	elif nanpa == 2:
		out+= "tu"
	elif nanpa == 3:
		out += "tu&wan"
	elif nanpa == 4:
		out+="tu&tu"
	elif nanpa == 5:
		out+="luka"
	return out

func update_display():
	$RichTextLabel.text =  toki_nanpa(current)+ "/" +toki_nanpa(limit) 
