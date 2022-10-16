extends TextureRect

var ShowAnswers = false

var SelectedQuestions = []
var SelectedAnswers = []

var RoundNumber = 1
onready var SelectingPrac = get_parent().get_parent().get_node("Selecting Practice")

export (PackedScene) var Quiz
export (PackedScene) var Flash
export (PackedScene) var typing
export (PackedScene) var Word

export (Array, Texture) var RoundTextures

var QuizTime = false
var FlashTime = false
var TypingTime = false
var WordTime = false

func _process(_delta):
	SelectingPrac.GoToGame()
	get_node("Label").text = "Round: " + str(RoundNumber)
	if QuizTime == true:
		if get_parent().get_node("Question & Answer") == null:
			RoundNumber = 2
			UpdateText()
	if FlashTime == true:
		if get_parent().get_node("Flash Card") == null:
			RoundNumber = 3
			UpdateText()
	if TypingTime == true:
		if get_parent().get_node("Typing") == null:
			RoundNumber = 4
			UpdateText()
	if WordTime == true:
		if get_parent().get_node("Word Game") == null:
			Finality()
	
	# If any of the things are doing stuff...
	if WordTime == true || TypingTime == true || FlashTime == true || QuizTime == true:
		get_node(".").visible = false
	else:
		get_node(".").visible = true
func _on_Begin_pressed():
	get_node("Music").stop()
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
		4:
			var Item = Word.instance()
			get_parent().add_child(Item)
			Item.SelectedQuestions = SelectedQuestions.duplicate()
			Item.SelectedAnswers = SelectedAnswers.duplicate()
			Item.ShowAnswers = ShowAnswers
			Item.UpdateText()
			WordTime = true
	get_node(".").visible = false
# Needed so the previous code doesn't break
func UpdateText():
	match RoundNumber:
		1:
			get_node(".").texture = RoundTextures[0]
		2:
			get_node(".").texture = RoundTextures[1]
			QuizTime = false
		3:
			get_node(".").texture = RoundTextures[2]
			FlashTime = false
		4:
			get_node(".").texture = RoundTextures[3]
			TypingTime = false
	get_node(".").visible = true
	get_node("Music").play()

func Finality():
	get_node("Results").visible = true

func _on_Continue_pressed():
	SelectingPrac.BackToLevel()
	queue_free()
