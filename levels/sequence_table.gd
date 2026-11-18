@tool
extends Control

@export var lights:Array[Gate]
@export var trains: Array[Sequencer]
@export var values: Array[int]:
	set(new):
		values = new
		resetrows()
	
@export var reload:bool=false:
	set(new):
		if Engine.is_editor_hint():
			reload= true
			generate()
@export var length= 0
var roworder = []
var validated_rows:Array[int]= []
var running = false

func _ready() -> void:
	generate()
	if not Engine.is_editor_hint():
		if get_parent() is Level:
			get_parent().edited.connect(_reset_validated)
		for train in trains:
			train.get_node("Tawa").pressed.connect(runTrains)
		
func resetrows():
	length =0
	for train:Sequencer in trains:
		if train.length > length:
			length = train.length
	roworder=[]

func traincell(val:int, validated:int):
	var back = ""
	var colorname = Sequencer.colorsets[length][val]
	if validated ==1:
		back = " bg=#aaffee"
	elif validated ==-1:
		back = " bg=#ffaaaa"
	else:
		
		back = " bg=#"+Sequencer.colors[colorname].to_html(false)
	return "[cell" + back+"][center]"+colorname+"[/center][/cell]"
	
func lightcell(val:int, validated:int):
	var back = ""
	if validated ==1:
		back = " bg=#aaffee"
	elif validated ==-1:
		back = " bg=#ffaaaa"
	if val == 1:
		return "[cell" + back+"][center]wawa[/center][/cell]"
	elif val == 0:
		return "[cell" + back+"][center]ala[/center][/cell]"
	elif val == -1:
		return "[cell" + back+"][center]mun[/center][/cell]"

func generate():
	if len(lights)==0:
		$TableLabel.text = "ilo suno e ala"
		return
	if len(trains)==0:
		$TableLabel.text = "tomo tawa e ala"
		return
	if len(roworder) == 0:
		generate_rows()
	
	var txt= "[table=2]"
	#header
	txt+= "[cell padding=2,2,2,2][center]tomo tawa[/center][/cell] 
[cell ][center]ilosuno[/center][/cell]"
	txt+="[cell][table=1]"
	#subheader
	txt+="[cell][tomo tawa][/cell]"
	#body
	for i in range(length):
		var validated = validated_rows[i]
		txt +=traincell(i,validated)
	txt+="[/table][/cell]"
	txt+="[cell padding=-4,0,0,0][table="+str(len(lights))+"]"
	#subheader
	for light in lights:
		txt+="[cell]["+light.nimi+"][/cell]"
	for i in range(length):
		var validated = validated_rows[i]
		for cell in roworder[i]:
			txt +=lightcell(cell,validated)
	txt+="[/table][/cell]"
	$TableLabel.text = txt
	if Engine.is_editor_hint() and get_tree().edited_scene_root !=null :
		$TableLabel.size.x = max(500, 200*(1+len(lights)))
func generate_rows():
	for i in range(length):
		roworder.append(values.slice(len(lights)*i,len(lights)*(i+1)))
		validated_rows.append(0)



func _reset_validated():
	validated_rows = []
	validated_rows.resize(length)
	_attempt_validate()
	generate()

func _attempt_validate():
	var i = trains[0].state-1
	if i >=0 and i < length:
		var target = roworder[i]
		var valid = true
		for j in len(lights):
			if lights[j].value != target[j]:
				valid = false
				break
		if valid:
			validated_rows[i] = 1
		else:
			validated_rows[i] = -1
		generate()	
	else:
		var win = validated_rows.reduce(func(acc,val): return acc and (val ==1), true)
		if win and get_parent() is Level:
			get_parent().win() 



		
func runTrains():
	if ! running:
		running = true
		for i in range(length+1):
			for train:Sequencer in trains:
				train.advance()
			_attempt_validate()
			await get_tree().create_timer(.66).timeout
		running = false
		for train:Sequencer in trains:
			train.state = 0;
