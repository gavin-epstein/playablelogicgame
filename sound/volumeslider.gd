extends HSlider



@export var audio_bus_name := "Master"

@onready var _bus := AudioServer.get_bus_index(audio_bus_name)


func _ready() -> void:
	LoadSettings.loadfile()
	value = LoadSettings.get_setting("audio", audio_bus_name, .8)
	drag_ended.connect(func(_changed: bool) -> void:
		LoadSettings.save())
	value_changed.connect(_on_HSlider_value_changed)

func _on_HSlider_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear_to_db(val))
	LoadSettings.set_setting("audio", audio_bus_name, val)
