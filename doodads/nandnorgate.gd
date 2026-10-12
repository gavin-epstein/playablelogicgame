extends Gate

func calculate():
	var a = input("0")
	var b = input("1")
	if a >0 and b >0:
		output("nand",0)
	elif a<0 and b<0:
		output("nand",-1)
	else:
		output("nand",1)
	if a+b > 0:
		output("nor",0)
	elif a+b == 0:
		output("nor",1)
	elif a+b  <0:
		output("nor", -1)
