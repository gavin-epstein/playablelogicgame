extends Node2D

@export var gateScene:PackedScene
@export var icon:Texture
@export var counter:SpawnLimiter
@export var gatescale =.1


func _ready() -> void:
	$Button/TextureRect.texture = icon
	
	



func _on_button_pressed() -> void:
	if counter.current < counter.limit:
		counter.current+=1
		var gate = gateScene.instantiate()
		get_parent().add_child(gate)
		gate.position = self.position+Vector2(randf_range(-100,100), randf_range(100,500))
		gate.scale = Vector2(gatescale,gatescale)
		gate.spawned = true
		gate.name = gate.name.replace("@","_")
