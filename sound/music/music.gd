extends Node


func _on_audio_stream_player_finished() -> void:
	await get_tree().create_timer(4).timeout
	$AudioStreamPlayer.play()
