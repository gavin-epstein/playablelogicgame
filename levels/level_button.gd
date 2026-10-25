class_name LevelButton extends Button
@export var levelnumber=0

func _ready() -> void:
	updateState()
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)
	GlobalProgress.updateProgress.connect(updateState)
	
func _on_pressed() -> void:
	$AudioStreamPlayer.play_randomized()
	await $AudioStreamPlayer.finished
	GlobalProgress.loadLevel(levelnumber)


func updateState():
	$Check.visible =  (levelnumber in GlobalProgress.completed)
	if levelnumber > len(GlobalProgress.completed)+GlobalProgress.UnlockedAtATime:
		disabled =  true
	else:
		disabled = false
		
