@tool
class_name Sequencer extends Gate
@export var length=0:
	set(val):
		if val != length and Engine.is_editor_hint():
			length = val
			regenerate()
		else:
			length=val
@export var nimi:String:
	set(val):
		nimi = val
		$House2/TextureRect3/Label.text = nimi
const railsegmentscene = preload("res://doodads/railsegment.tscn")
const terminal = preload("res://doodads/terminal.tscn")
const colors = {
	"loje laso":Color("ff55aa"),
	"loje":Color("ff8888"),
	"loje jelo":Color("ff9955"),
	"jelo loje":Color("ffcc66"),
	"jelo":Color("ffff55"),
	"jelo laso":Color("aaff55"),
	"laso jelo":Color("88ffbb"),
	"laso":Color("55ccff"),
	"laso loje":Color("aa55ff")	
}
const colorsets = {
	2:["loje","laso"],
	3:["loje","jelo","laso"],
	4:["loje","jelo","laso jelo","laso loje"],
	5:["loje","jelo loje","jelo laso","laso","laso loje"],
	6:["loje","loje jelo","jelo","jelo laso","laso","laso loje"],
	7:["loje laso","loje","loje jelo","jelo","jelo laso","laso","laso loje"],
	8:["loje laso","loje","loje jelo","jelo","jelo laso","laso jelo","laso","laso loje"],
	9:["loje laso","loje","loje jelo","jelo","jelo loje","jelo laso","laso jelo","laso","laso loje"]
}
var state=0

func _ready():
	if !Engine.is_editor_hint():
		super()
		set_colors()

func calculate():
	if !Engine.is_editor_hint():
		if state == 0:
			output("out",0)
		else:
			var a = input("Terminal"+str(state))
			output("out",a)
			
		
func set_colors():
	for i in range(length):
		var colorname = colorsets[length][i]
		var segment:RailSegment = get_node(colorname)
		segment.setcolor(colors[colorname], colorname)
func regenerate():
	if Engine.is_editor_hint():
		if length <2 or length >9:
			print("Invalid Length, try again or add more colors")
			return
		for child in get_children():
			if child is RailSegment:
				child.queue_free()
			elif child is WireTerminal and child.name!="out":
				child.queue_free()
		for i in range(length):
			var segment:RailSegment = railsegmentscene.instantiate()
			add_child(segment)
			segment.owner = get_tree().edited_scene_root
			segment.position.y = i*850;
			var colorname = colorsets[length][i]
			segment.setcolor(colors[colorname], colorname)
			segment.name = colorname
			var term:WireTerminal = terminal.instantiate()
			add_child(term)
			term.owner = get_tree().edited_scene_root
			term.position = Vector2(-708,i*850)
			term.scale = Vector2(.5,.5)
			term.name = "Terminal"+str(i+1)
			
		$House2.position.y = length*850;	
		$draggable/CollisionShape2D.position.y = (length-1)*850/2
		$draggable/CollisionShape2D.shape.size.y = (length+2)*850

func advance():
	state += 1
	$Train.go_to_position(state)
	calculate()
