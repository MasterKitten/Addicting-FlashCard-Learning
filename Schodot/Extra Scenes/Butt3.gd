extends Button

var ItemThing = 0

func _on_Button3_pressed():
	get_parent().get_parent().get_parent().get_node(".").Answer(ItemThing)
