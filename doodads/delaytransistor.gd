extends Gate
var lastvals = {"0":0,"2":1}
@onready var delay = .75*randi_range(1,6)

func _explode():
	pass

func calculate():
	var out0 = 0
	if input("0") == 0 and input("1") == 0 and input("2") ==0:
		out0=1
	get_tree().create_timer(delay).timeout.connect(delay_output.bindv(["0",out0]))
	
	var out2 =0
	if input("0") == 0:
		out2 = input("1")
	get_tree().create_timer(delay).timeout.connect(delay_output.bindv(["2",out2]))
	output("2", lastvals["2"])
	output("0",lastvals["0"])

func delay_output(nname,val):
	lastvals[nname] = val
	output(nname, val)
