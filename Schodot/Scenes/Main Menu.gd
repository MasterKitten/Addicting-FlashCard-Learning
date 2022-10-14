extends TextureRect
# Buttons
func _on_Play_pressed():
	get_node("AnimationPlayer").play("Slide")

func _on_Magic_pressed():
	var _nill = get_tree().change_scene("res://Scenes/Creation.tscn")

func _on_Setting_pressed():
	var _nill = get_tree().change_scene("res://Scenes/Settings.tscn")

var trus = false

func _on_About_pressed():
	trus = !trus
	if trus == true:
		get_node("ColorRect").visible = false
		get_node("ColorRect2").visible = false
		get_node("ColorRect3").visible = false
		get_node("RichTextLabel").visible = false
		get_node("RichTextLabel2").visible = false
		get_node("About").visible = true
	else:
		get_node("ColorRect").visible = true
		get_node("ColorRect2").visible = true
		get_node("ColorRect3").visible = true
		get_node("RichTextLabel").visible = true
		get_node("RichTextLabel2").visible = true
		get_node("About").visible = false
