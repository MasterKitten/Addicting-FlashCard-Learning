extends TextureRect

func _on_Play_pressed():
	queue_free()

func _on_Magic_pressed():
	var _nill = get_tree().change_scene("res://Scenes/Creation.tscn")
