extends Sprite2D
@export var silent = false

func _ready() -> void:
	if !silent:
		$AudioStreamPlayer.play_randomized()
