extends TextureRect

export (Array, Array, String) var Questions
export (Array, Array, String) var Answers
export (Array, String) var Groups

export (Array, String) var SelectedAnswers
export (Array, String) var SelectedQuestions

export (PackedScene) var Butt

export (PackedScene) var QuizScene
export (PackedScene) var FlashScene

var ItemToDo = 0

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

func _on_Quiz_pressed():
	InsertThings()
	var Item = QuizScene.instance()
	get_parent().get_node(".").add_child(Item)
	Item.SelectedQuestions = SelectedQuestions
	Item.SelectedAnswers = SelectedAnswers
	Item.UpdateText()
	GoToGame()

func _on_Flash_pressed():
	InsertThings()
	var Item = FlashScene.instance()
	get_parent().add_child(Item)
	Item.SelectedQuestions = SelectedQuestions
	Item.SelectedAnswers = SelectedAnswers
	Item.UpdateText()
	GoToGame()

func InsertThings():
	var i = 0
	SelectedAnswers = []
	SelectedQuestions = []
	while i < Questions[ItemToDo].size():
		var Thing = Questions[ItemToDo][i]
		SelectedQuestions.append(Thing)
		i += 1
	i = 0
	while i < Answers[ItemToDo].size():
		var Thing = Answers[ItemToDo][i]
		SelectedAnswers.append(Thing)
		i += 1

func Popups(ItemThing):
	ItemToDo = ItemThing
	get_node("WindowDialog").popup()

func GoToGame():
	get_node("Music").stop()
	get_node("WindowDialog").visible = false
	get_node(".").visible = false

func BackToLevel():
	get_node("Music").play()
	get_node(".").visible = true

func _on_Quit_pressed():
	var _nill = get_tree().change_scene("res://Defaults/Main Scene.tscn")
