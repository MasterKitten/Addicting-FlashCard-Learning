extends TextureRect

var SelectedQuestions = []
var SelectedAnswers = []

var RandomQuestion = 0
var ShowAnswers = false
onready var SelectingPrac = get_parent().get_parent().get_node("Selecting Practice")

export (PackedScene) var Butt

var Correct = 0
var Wrong = 0
var Total = 0
var Dumb = false

func Answer(Number):
	if Number == RandomQuestion:
		Correct += 1
	else:
		Wrong += 1
	SelectedQuestions.remove(RandomQuestion)
	SelectedAnswers.remove(RandomQuestion)
	var Children = get_node("ScrollContainer/Container").get_children()
	var i = 0
	while i < Children.size():
		Children[i].queue_free()
		i += 1
	if SelectedAnswers.size() == 0:
		Finality()
	else:
		UpdateText()

func UpdateText():
	if Dumb == false:
		Total = SelectedAnswers.size()
		Dumb = true
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

func Finality():
	get_node("Results/Correct").text = "Correct: " + str(Correct)
	get_node("Results/Wrong").text = "Wrong: " + str(Wrong)
	get_node("Results/Progress2").text = str(Correct) + " / " + str(Total)
	get_node("Results").visible = true

func _on_Continue_pressed():
	SelectingPrac.BackToLevel()
	queue_free()
