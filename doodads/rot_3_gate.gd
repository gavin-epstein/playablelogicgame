extends Gate


func calculate():
	var sum =( input("in0")+input("in1")+input("in2")+6) %3
	if sum ==0:
		$Across.visible=true
		$up.visible = false
		output("out0",input("in0"))
		output("out1",input("in1"))
		output("out2",input("in2"))
	elif sum ==1:
		$Across.visible=false
		$up.visible = true
		$up.flip_v = false
		output("out0",input("in1"))
		output("out1",input("in2"))
		output("out2",input("in0"))
	elif sum ==2:
		$Across.visible=false
		$up.visible = true
		$up.flip_v = true
		output("out0",input("in2"))
		output("out1",input("in0"))
		output("out2",input("in1"))
