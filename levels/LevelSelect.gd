@tool
class_name LevelSelect extends GridContainer
var buttonScene

@export var reload:bool=false:
	set(new):
		if Engine.is_editor_hint():
			reload= true
			generate()
@export var page=0

func _ready() -> void:
	if !Engine.is_editor_hint():
		@warning_ignore("integer_division")
		page = GlobalProgress.last_level/25 
		generate()

func generate():
		if Engine.is_editor_hint():
			if get_tree()!=null:
				GlobalProgress.loadScenes()
			else:
				return
		if buttonScene == null:
			buttonScene = load("res://levels/level_button.tscn")
		for child in get_children():
			if child is LevelButton:
				child.queue_free()
		for i in range(25*page, min(GlobalProgress.totalLevels+1,(page+1)*25)):
			var button:LevelButton = buttonScene.instantiate()
			add_child(button)
			if  Engine.is_editor_hint():
				button.owner = get_tree().edited_scene_root
			button.name = "Button"+str(i+1)
			button.levelnumber = i+1
			button.text = SpawnLimiter.toki_nanpa(i+1)
			if i+1 > 20:
				button.add_theme_font_size_override("font_size",20)
			button.updateState()
		$"../LevelselectPrev".visible = true
		$"../LevelselectNext".visible = true
		if page == 0:
			$"../LevelselectPrev".visible = false
		elif page == 3:
			$"../LevelselectNext".visible = false

func changePage(val):
	page+=val
	print(page)
	generate()
	
