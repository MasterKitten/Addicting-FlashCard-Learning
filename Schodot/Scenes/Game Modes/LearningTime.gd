extends TextureRect

var ShowAnswers = false

var SelectedQuestions = []
var SelectedAnswers = []

var RoundNumber = 1

export (PackedScene) var Quiz
export (PackedScene) var Flash
export (PackedScene) var typing

var QuizTime = false
var FlashTime = false
var TypingTime = false

func _process(_delta):
	get_parent().get_node("Selecting Practice").GoToGame()
	get_node("Label").text = "Round: " + str(RoundNumber)
	if QuizTime == true:
		if get_parent().get_node("Question & Answer") == null:
			RoundNumber = 2
			QuizTime = false
			get_node(".").visible = true
	if FlashTime == true:
		if get_parent().get_node("Flash Card") == null:
			RoundNumber = 3
			FlashTime = false
			get_node(".").visible = true
	if TypingTime == true:
		if get_parent().get_node("Typing") == null:
			get_parent().get_node("Selecting Practice").BackToLevel()
			queue_free()

func _on_Begin_pressed():
	match RoundNumber:
		1:
			var Item = Quiz.instance()
			get_parent().add_child(Item)
			Item.SelectedQuestions = SelectedQuestions.duplicate()
			Item.SelectedAnswers = SelectedAnswers.duplicate()
			Item.ShowAnswers = ShowAnswers
			Item.UpdateText()
			QuizTime = true
		2:
			var Item = Flash.instance()
			get_parent().add_child(Item)
			Item.SelectedQuestions = SelectedQuestions.duplicate()
			Item.SelectedAnswers = SelectedAnswers.duplicate()
			Item.ShowAnswers = ShowAnswers
			Item.UpdateText()
			FlashTime = true
		3:
			var Item = typing.instance()
			get_parent().add_child(Item)
			Item.SelectedQuestions = SelectedQuestions.duplicate()
			Item.SelectedAnswers = SelectedAnswers.duplicate()
			Item.ShowAnswers = ShowAnswers
			Item.UpdateText()
			TypingTime = true
	get_node(".").visible = false
# Needed so the previous code doesn't break
func UpdateText():
	pass
