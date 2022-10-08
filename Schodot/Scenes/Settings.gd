extends ColorRect

var Master = AudioServer.get_bus_index("Master")
var Music = AudioServer.get_bus_index("Music")

func _on_Music_Bar_value_changed(value):
	AudioServer.set_bus_volume_db(Music, linear2db(value))

func _on_Master_Bar_value_changed(value):
	AudioServer.set_bus_volume_db(Master, linear2db(value))

func _on_Master_Bar_drag_ended(_value_changed):
	get_node("AudioTest").play()

func _on_Button_pressed():
	var _nill = get_tree().change_scene("res://Defaults/Main Scene.tscn")
