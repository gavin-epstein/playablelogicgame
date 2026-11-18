@tool
class_name LevelSelect extends GridContainer
var buttonScene

@export var reload:bool=false:
	set(new):
		if Engine.is_editor_hint():
			reload= true
			generate()
	
	


func generate():
	if Engine.is_editor_hint() and get_tree()!=null:
		GlobalProgress.loadScenes()
		if buttonScene == null:
			buttonScene = load("res://levels/level_button.tscn")
		for child in get_children():
			if child is LevelButton:
				child.queue_free()
		for i in range(GlobalProgress.totalLevels):
			var button:LevelButton = buttonScene.instantiate()
			add_child(button)
			button.owner = get_tree().edited_scene_root
			button.name = "Button"+str(i+1)
			button.levelnumber = i+1
			button.text = SpawnLimiter.toki_nanpa(i+1)
			if i+1 > 20:
				button.add_theme_font_size_override("font_size",20)
			
