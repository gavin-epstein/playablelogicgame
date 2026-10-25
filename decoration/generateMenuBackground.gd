extends Node2D
var delaytransistor = preload("res://doodads/delaytransistor.tscn")
var wireScene = preload("res://doodads/Wire.tscn")
var constgate = preload("res://doodads/const_1_gate.tscn")
var rows = 4
var cols = 8
var grid = []

func _ready() -> void:
	generate()

func generate():
	var w= get_viewport_rect().size.x
	var h = get_viewport_rect().size.y
	#gates
	for x in range(0,w+1,w/cols):
		var row = []
		for y in range(0,h+1,h/rows):
			
			var trans:Gate
			if (x==0 or x>=w) and (y ==0 or y>=w):
				trans = constgate.instantiate()
			else:
				trans= delaytransistor.instantiate()
			add_child(trans)
			trans.position = Vector2(x,y)
			trans.scale = Vector2(.07,.07)
			trans.rotation = PI/4 * randi_range(0,7)
			row.append(trans)
		grid.append(row)
	#wires
	#print(len(grid),len(grid[0]))
	for ax in range(len(grid)):
		var x = (ax*5+2)%len(grid)
		for ay in range(len(grid[0])):
			var y= (ay*3+2) % len(grid[0])

			var trans:Gate = grid[x][y]
			for child in trans.get_children():
				if child is WireTerminal and child.wire == null :
					var poss = []
					for dx in range(-1,2):
						for dy in range(-1,2):
							if (not(dx==0 and dy==0)) and (dx==0 or dy==0) and x+dx < len(grid) and y + dy < len(grid[0]) and x+dx > 0  and y+dy>0 :
								for otherchild in grid[x+dx][y+dy].get_children():
									if otherchild is WireTerminal and otherchild.wire == null:
										poss.append(otherchild)
					if len(poss) > 0:
						var other:WireTerminal = poss[randi_range(0,len(poss)-1)]
						var wire:Wire = wireScene.instantiate()
						wire.scale.y = .01
						wire.term1 = child
						wire.connect_wire_editor(child)
						wire.term2 = other
						wire.connect_wire_editor(other)
						add_child(wire)


	
			
	
