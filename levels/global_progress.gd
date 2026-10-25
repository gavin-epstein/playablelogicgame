@tool
class_name globalProgress extends Node
const PATH := "user://save.json"
const mainmenuScene = preload("res://levels/main_menu.tscn")
const winscreen = preload("res://levels/oneoff/Endscreen.tscn")
const LEVELPATH = "res://levels/actualLevels/"
@export var levelScenes = []

@export var reload:bool=false:
	set(new):
		if Engine.is_editor_hint():
			reload= true
			loadScenes()

var currentLevel = 0
@export var totalLevels = 0

var inProgressScenes = {}
var completed = []
signal updateProgress
const UnlockedAtATime = 5
var loaded = false

func loadScenes():
	levelScenes = []
	if Engine.is_editor_hint():
		var file = FileAccess.open("res://levels/levellist.txt", FileAccess.READ)
		while file.get_position()  < file.get_length():
			var line = file.get_line()
			if not line.begins_with("#"):
				var levelname = LEVELPATH + line.strip_edges()+".tscn"
				var level = load(levelname)
				if level is PackedScene:
					levelScenes.append(level)
					
		totalLevels = len(levelScenes)
		print(totalLevels, "levels loaded")
func completeLevel():
	completed.append(currentLevel)
	save()

func nextLevel():
	
	updateProgress.emit()
	loadLevel(currentLevel+1)

func saveLevelToData() -> Dictionary:
	var level:Level 
	for i in get_tree().root.get_children():
		if i is Level:
			level = i
	if level==null:
		return {}
	var d = {}
	d["base"] = currentLevel
	d["gates"] = []
	d["wires"] = []
	for child in level.get_children():
		if child is Gate:
			d["gates"].append(child.save())
		elif child is Wire:
			d["wires"].append(child.save())
	return d
	
func loadLevelFromData(d:Dictionary):

	get_tree().change_scene_to_packed(levelScenes[d["base"]-1])
	await get_tree().create_timer(0).timeout #im sure theres a better way to wait until the scene is loaded but idk what it is
	var level:Level 
	for i in get_tree().root.get_children():
		if i is Level:
			level = i
	if level==null:
		print("missing level")
	for gated in d["gates"]:
		var gate:Gate = level.get_node(gated["path"])
		if gate!=null:
			gate.load_from_save(gated)
		else:
			gate = load(gated["resource"]).instantiate()
			level.add_child(gate)
			gate.load_from_save(gated)
	for wired in d["wires"]:
		var wire:Wire = level.get_node(wired["path"])
		if wire==null:
			wire = WireTerminal.wireScene.instantiate()
			level.add_child(wire)
			wire.load_from_save(wired)
	level.edited.emit()

func loadLevel(i, reset = false):
	
	if currentLevel !=0:
		var scn = saveLevelToData()
		if len(scn.keys())>0:
			inProgressScenes[currentLevel]= scn
	currentLevel = i
	if i ==0:
		get_tree().change_scene_to_packed(mainmenuScene)
	else:
		if i in inProgressScenes.keys() and not reset:
			loadLevelFromData(inProgressScenes[i])
		else:
			if i>len(levelScenes):
				get_tree().change_scene_to_packed(winscreen)
			else:
				get_tree().change_scene_to_packed(levelScenes[i-1])
	save()
	
func save():
	var save_file = FileAccess.open(PATH, FileAccess.WRITE)
	var savedata={
		"current": currentLevel,
		"completed":completed
	}
	var json_string = JSON.stringify(savedata)
	save_file.store_line(json_string)
	
func loadsave():
	var save_file = FileAccess.open(PATH, FileAccess.READ)
	if save_file !=null:
		var json_string = save_file.get_line()
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		else:
			currentLevel = json.data["current"]
			completed = json.data["completed"]
			for i in range(len(completed)):
				completed[i]=int(completed[i])
	loaded = true
	
			
		
