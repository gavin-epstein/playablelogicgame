class_name Level extends Node2D
const nextButtonScene =  preload("res://levels/goNext.tscn")
var update_queue=[]
@warning_ignore("unused_signal") signal edited
var won = false
var processing=false
func win():
	if !won:
		won=true
		GlobalProgress.completeLevel()
		var nextButton = nextButtonScene.instantiate()
		add_child(nextButton)


func add_to_update_queue(doodad:Doodad):
	if doodad not in update_queue:
		update_queue.append(doodad)
		if not processing:
			process_queue()
		

func process_queue():
	processing = true
	while len(update_queue)>0:
		var doodad:Doodad = update_queue.pop_front()
		doodad.process_from_queue()
		#print(len(update_queue))
	processing = false
