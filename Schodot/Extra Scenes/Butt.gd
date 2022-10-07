extends Button

export var ItemThing = 0

func _on_Button_pressed():
	# Edit the groups
	get_parent().get_parent().get_parent().get_node("Selected Group").text = "Selected Group: " + self.text
	print(ItemThing)
	get_parent().get_parent().get_parent().SelectedGroup = self.ItemThing
	get_parent().get_parent().get_parent().Pingas()
	# Edit the items
	get_parent().get_parent().get_parent().get_node("Selected Items").text = "Selected Input: "
	get_parent().get_parent().get_parent().SelectedLabel = -1
