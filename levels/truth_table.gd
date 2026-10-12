@tool
extends Control
@export var lights:Array[Gate]
@export var switches: Array[Lever]
@export var values: Array[int]:
	set(new):
		values = new
		resetrows()
@export var onlyshowRows: Array[int]:
	set(new):
		onlyshowRows = new
		resetrows()
	
@export var reload:bool=false:
	set(new):
		reload= true
		generate()
var rows:Dictionary = {}
var roworder = []
var validated_rows:Dictionary = {}

func _ready() -> void:
	generate()
	if not Engine.is_editor_hint():
		if get_parent() is Level:
			get_parent().edited.connect(_reset_validated)
		for switch in switches:
			switch.statechanged.connect(_attempt_validate)
		
func resetrows():
	rows = {}
	roworder=[]

func switchcell(val:int, validated:int):
	var back = ""
	if validated ==1:
		back = " bg=#aaffee"
	elif validated ==-1:
		back = " bg=#ffaaaa"
	if val == 1:
		return "[cell" + back+"][center]sewi2[/center][/cell]"
	elif val == 0:
		return "[cell" + back+"][center]anpa[/center][/cell]"
	elif val == -1:
		return "[cell" + back+"][center]insa[/center][/cell]"
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
	if len(switches)==0:
		$TableLabel.text = "ilo pi(open pine) e ale"
		return
	if len(rows) == 0:
		generate_rows()
	var txt= "[table=2]"
	#header
	txt+= "[cell padding=2,2,2,2][center]ilo pi(open pini)[/center][/cell] 
[cell ][center]ilosuno[/center][/cell]"
	txt+="[cell][table="+str(len(switches))+"]"
	#subheader
	for switch in switches:
		txt+="[cell]["+switch.nimi+"][/cell]"
	#body
	for row in roworder:
		var validated = 0
		if row_to_key(row) in validated_rows.keys():
			validated= validated_rows[row_to_key(row)]
		for cell in row:
			txt +=switchcell(cell,validated)
	txt+="[/table][/cell]"
	txt+="[cell padding=-4,0,0,0][table="+str(len(lights))+"]"
	#subheader
	for light in lights:
		txt+="[cell]["+light.nimi+"][/cell]"
	for row in roworder:
		var validated = 0
		if row_to_key(row) in validated_rows.keys():
			validated= validated_rows[row_to_key(row)]
		for cell in rows[row_to_key(row)]:
			txt +=lightcell(cell,validated)
	txt+="[/table][/cell]"
	$TableLabel.text = txt
	$TableLabel.size.x = max(500, 200*(len(switches)+len(lights)))
func generate_rows():
	
	var current:Array[int] =[]
	for i in range(len(switches)):
		current.append(1)
	var currow = 0
	while true:
		if len(onlyshowRows)==0 or currow in onlyshowRows:
			rows[row_to_key(current)] = values.slice(len(lights)*currow,len(lights)*(currow+1))
			roworder.append(current.duplicate())
		currow +=1
		var gate = len(switches)-1
		while true:
			current[gate] -=1
			if (current[gate] < 0 and switches[gate] is Levermux2) or (current[gate] < -1 and switches[gate] is Levermux3):
				current[gate]=1
				if gate ==0:
					return
				gate-=1	
			else:
				break

static func row_to_key(row:Array[int]):
	return row.reduce(func (acc,num): return acc+str(num)+",","")


func _reset_validated():
	validated_rows = {}
	_attempt_validate()
	generate()

func _attempt_validate():
	var curswitch:Array[int] = []
	for switch:Lever in switches:
		curswitch.append(switch.state)
	if row_to_key(curswitch) in rows.keys() and row_to_key(curswitch) not in validated_rows.keys():
		var target = rows[row_to_key(curswitch)]
		var valid = true
		for i in len(lights):
			
			if lights[i].value != target[i]:
				valid = false
				break
		if valid:
			validated_rows[row_to_key(curswitch)] = 1
		else:
			validated_rows[row_to_key(curswitch)] = -1
		generate()	
		if len(validated_rows.keys()) == len(roworder):
			var win = validated_rows.values().reduce(func(acc,val): return acc and (val ==1), true)
			if win and get_parent() is Level:
				get_parent().win() 


func _on_lukinale_pressed() -> void:
	var speed = 1./len(rows)
	for row in roworder:
		for i in range(len(switches)):
			switches[i].set_state(row[i])
		_attempt_validate()
		await(get_tree().create_timer(speed).timeout)
