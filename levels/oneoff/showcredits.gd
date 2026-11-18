extends Button


func _on_pressed() -> void:
	$Control.visible = !$Control.visible 


func _on_close_pressed() -> void:
	$Control.visible = false
