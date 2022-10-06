extends Button

export var ItemThing = 0

func _on_Button_pressed():
	# Edit the items
	get_parent().get_parent().get_parent().get_node("Selected Items").text = "Selected Input: " + self.text
	get_parent().get_parent().get_parent().SelectedLabel = self.ItemThing
