extends Gate


func calculate():
	if input("0") > 0 and input("1") > 0:
		output("2",1)
	elif input("0") < 0 and input("1") < 0:
		output("2",-1)
	else:
		output("2",0)
	
