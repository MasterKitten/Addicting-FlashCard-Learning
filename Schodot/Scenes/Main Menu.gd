extends TextureRect

func _on_Play_pressed():
	get_node("AnimationPlayer").play("Slide")

func _on_Magic_pressed():
	var _nill = get_tree().change_scene("res://Scenes/Creation.tscn")
