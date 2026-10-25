extends Button

const mainmenuScene = preload("res://levels/main_menu.tscn")




func _on_pressed() -> void:
	$AudioStreamPlayer.play_randomized()
	await $AudioStreamPlayer.finished
	
	GlobalProgress.loadLevel(0)
