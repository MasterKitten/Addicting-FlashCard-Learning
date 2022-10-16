extends TextureRect

var SelectedQuestions = []
var SelectedAnswers = []
var ShowAnswers = false #Leave this variable alone

var Flipped = false
var CurrentQuestion = 0

onready var animator = get_node("AnimationPlayer")
onready var SelectingPrac = get_parent().get_parent().get_node("Selecting Practice")

func UpdateText():
	# This sets the text in the middle of the animation
	if Flipped == true && CurrentQuestion != SelectedQuestions.size():
		get_node("Label").text = SelectedAnswers[CurrentQuestion]
		get_node("Label2").text = "Answer:"
	elif CurrentQuestion != SelectedQuestions.size():
		get_node("Label").text = SelectedQuestions[CurrentQuestion]
		get_node("Label2").text = "Question:"
	# set the next text to finish if its at the last card.
	get_node("Next").text = "Next"
	if CurrentQuestion == SelectedQuestions.size() - 1:
		get_node("Next").text = "Finish"

func _on_Flip_pressed():
	# Flips the card, revealing the answere
	if Flipped == true:
		Flipped = false
	else:
		Flipped = true
	animator.play("Flip")

func _on_Next_pressed():
	# Goes to the next question.If its at the last one, end the flash card game.
	CurrentQuestion += 1
	animator.play("NextCard")
	Flipped = false
	if CurrentQuestion == SelectedQuestions.size():
		get_node("AnimationPlayer").play("FadeOut")
	get_node("Back").visible = true
	UpdateText()

# go back one card. If we are at the beginning, no more visibility.
func _on_Back_pressed():
	CurrentQuestion -= 1
	animator.play("LastCard")
	Flipped = false
	if CurrentQuestion == 0:
		get_node("Back").visible = false
	else:
		get_node("Back").visible = true
	UpdateText()

func Back():
	SelectingPrac.BackToLevel()
	queue_free()
