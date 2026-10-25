extends Button


func _on_pressed() -> void:
	$AudioStreamPlayer.play_randomized()
	await $AudioStreamPlayer.finished
	GlobalProgress.loadLevel(GlobalProgress.currentLevel,true)
