extends GateArea
@export var spawnLimiter:SpawnLimiter

func onDropped(gate:Gate):
	if gate.spawned:
		for child in gate.get_children():
			if child is WireTerminal:
				if child.wire!=null:
					child.wire.delete_wire()
		gate.queue_free()
		spawnLimiter.current-=1
		$AudioStreamPlayer.play_randomized()
