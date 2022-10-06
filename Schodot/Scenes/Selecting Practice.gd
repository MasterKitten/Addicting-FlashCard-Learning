extends TextureRect

export (Array, Array, String) var Questions
export (Array, Array, String) var Answers
export (Array, String) var Groups

export (Array, String) var SelectedAnswers
export (Array, String) var SelectedQuestions

export (PackedScene) var Butt
export (PackedScene) var TheScened

func Populate(datas):
	Groups = datas.Groups
	Answers = datas.Answers
	Questions = datas.Questions
	var i = 0
	while i < Groups.size():
		var Item = Butt.instance()
		get_node("HFlowContainer").add_child(Item);
		var Items = get_node("HFlowContainer").get_children()
		Items[i].ItemThing = i
		Item.text = str(Item.ItemThing + 1) + ". " + Groups[i]
		i += 1

func Select(ItemThing):
	var i = 0
	while i < Questions[ItemThing].size():
		var Thing = Questions[ItemThing][i]
		SelectedQuestions.append(Thing)
		i += 1
	i = 0
	while i < Answers[ItemThing].size():
		var Thing = Answers[ItemThing][i]
		SelectedAnswers.append(Thing)
		i += 1
	var Item = TheScened.instance()
	get_node(".").add_child(Item)
	Item.SelectedQuestions = SelectedQuestions
	Item.SelectedAnswers = SelectedAnswers
	Item.UpdateText()

func _on_Quit_pressed():
	var _nill = get_tree().change_scene("res://Main Scene.tscn")
