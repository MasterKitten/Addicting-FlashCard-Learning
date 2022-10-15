extends TextureRect

var SelectedQuestions = []
var SelectedAnswers = []

var RandomQuestion = 0
var ShowAnswers = false
onready var SelectingPrac = get_parent().get_parent().get_node("Selecting Practice")

export (PackedScene) var Butt

func Answer(Number):
	if Number == RandomQuestion:
		print("Correct")
	else:
		print("Wrong")
	SelectedQuestions.remove(RandomQuestion)
	SelectedAnswers.remove(RandomQuestion)
	var Children = get_node("ScrollContainer/Container").get_children()
	var i = 0
	while i < Children.size():
		Children[i].queue_free()
		i += 1
	if SelectedAnswers.size() == 0:
		SelectingPrac.BackToLevel()
		queue_free()
	else:
		UpdateText()

func UpdateText():
	var i = 0
	while i < SelectedAnswers.size():
		var Item = Butt.instance()
		get_node("ScrollContainer/Container").add_child(Item)
		Item.ItemThing = i
		Item.text = SelectedAnswers[i]
		i += 1
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	RandomQuestion = RNG.randi_range(0, SelectedQuestions.size() - 1)
	get_node("TextureRect/RichTextLabel").text = SelectedQuestions[RandomQuestion]
