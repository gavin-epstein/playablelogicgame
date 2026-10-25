extends Control

func _ready() -> void:
	if not GlobalProgress.loaded:
		GlobalProgress.loadsave()
		if len(GlobalProgress.completed) == 0:
			GlobalProgress.loadLevel(1)
		else:
			GlobalProgress.updateProgress.emit()
