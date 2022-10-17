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

func Start(num):
	if num == 1:
		get_node("Animator2").play("FadeIn")
		get_node("Animator2").seek(0, true)
	elif num == 2:
		get_node("Animator2").play("FadeIn")
		get_node("Animator2").seek(0.4, true)

func _process(_delta):
	SelectingPrac.GoToGame()
	get_node("Label").text = "Round: " + str(RoundNumber)
	if QuizTime == true:
		if get_parent().get_node("Question & Answer") == null:
			QuizTime = false
			RoundNumber = 2
			get_node("Animator").play("SpinSpin")
			get_node("Animator2").play("FadeIn")
	if FlashTime == true:
		if get_parent().get_node("Flash Card") == null:
			FlashTime = false
			RoundNumber = 3
			get_node("Animator").play("SpinSpin")
			get_node("Animator2").play("FadeIn")
	if TypingTime == true:
		if get_parent().get_node("Typing") == null:
			TypingTime = false
			RoundNumber = 4
			get_node("Animator").play("SpinSpin")
			get_node("Animator2").play("FadeIn")
	if WordTime == true:
		if get_parent().get_node("Word Game") == null:
			WordTime = false
			Finality()
			get_node("Animator2").play("FadeIn")
	
	# If any of the things are doing stuff...
	if WordTime == true || TypingTime == true || FlashTime == true || QuizTime == true:
		get_node(".").visible = false
	else:
		get_node(".").visible = true

func SpawnThing():
	get_node("Music").stop()
	match RoundNumber:
		1:
			var Item = Quiz.instance()
			get_parent().add_child(Item)
			Item.SelectedQuestions = SelectedQuestions.duplicate()
			Item.SelectedAnswers = SelectedAnswers.duplicate()
			Item.ShowAnswers = ShowAnswers
			Item.UpdateText()
			Item.Start(2)
			QuizTime = true
		2:
			var Item = Flash.instance()
			get_parent().add_child(Item)
			Item.SelectedQuestions = SelectedQuestions.duplicate()
			Item.SelectedAnswers = SelectedAnswers.duplicate()
			Item.ShowAnswers = ShowAnswers
			Item.UpdateText()
			Item.Start(2)
			FlashTime = true
		3:
			var Item = typing.instance()
			get_parent().add_child(Item)
			Item.SelectedQuestions = SelectedQuestions.duplicate()
			Item.SelectedAnswers = SelectedAnswers.duplicate()
			Item.ShowAnswers = ShowAnswers
			Item.UpdateText()
			Item.Start(2)
			TypingTime = true
		4:
			var Item = Word.instance()
			get_parent().add_child(Item)
			Item.SelectedQuestions = SelectedQuestions.duplicate()
			Item.SelectedAnswers = SelectedAnswers.duplicate()
			Item.ShowAnswers = ShowAnswers
			Item.UpdateText()
			Item.Start(2)
			WordTime = true

func _on_Begin_pressed():
	get_node("Animator").play("FadeOut")
# Needed so the previous code doesn't break
func UpdateText():
	match RoundNumber:
		1:
			get_node(".").texture = RoundTextures[0]
		2:
			get_node(".").texture = RoundTextures[1]
		3:
			get_node(".").texture = RoundTextures[2]
		4:
			get_node(".").texture = RoundTextures[3]
	get_node(".").visible = true
	get_node("Music").play()

func Finality():
	get_node("Results").visible = true

func _on_Continue_pressed():
	get_node("Animator2").play("FadeOut")

func Back():
	SelectingPrac.BackToLevel()
	queue_free()
