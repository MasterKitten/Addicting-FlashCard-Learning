extends Button

export var ItemThing = 0

func _on_Button2_pressed():
	get_parent().get_parent().Select(ItemThing)
