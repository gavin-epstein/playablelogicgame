class_name Settings extends Node


const PATH := "user://settings.cfg"

var config := ConfigFile.new()
var loaded = false

func loadfile() -> void:
	if !loaded:
		var err := config.load(PATH)
		if err != OK and err != ERR_FILE_NOT_FOUND:
			push_warning("Settings: could not read %s (error %d), using defaults" % [PATH, err])
		apply_all()
		print("loaded")
	loaded = true

func get_setting(section: String, key: String, default_value: Variant) -> Variant:
	return config.get_value(section, key, default_value)

func set_setting(section: String, key: String, value: Variant) -> void:
	config.set_value(section, key, value)

func save() -> void:
	var err := config.save(PATH)
	if err != OK:
		push_error("Settings: save failed (error %d)" % err)
	else:
		print("settings saved")

func apply_all() -> void:
	apply_volume("Music")
	apply_volume("UI")
	
func apply_volume(bus_name: String) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	var linear: float = get_setting("audio", bus_name, .8)
	AudioServer.set_bus_volume_db(idx, linear_to_db(linear))
	AudioServer.set_bus_mute(idx, linear <= 0.001)
