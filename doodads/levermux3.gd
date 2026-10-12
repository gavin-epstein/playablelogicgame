class_name Levermux3 extends Lever

func calculate():
	if state ==1:
		output("out",input("top"))
	elif state == 0:
		output("out",input("bot"))
	elif state == -1:
		output("out",input("mid"))


func set_state(s:int):
	state = s
