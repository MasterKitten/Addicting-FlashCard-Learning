extends TextureRect

var SelectedQuestions = []
var SelectedAnswers = []
var ShowAnswers = false #Leave this variable alone

var Flipped = false
var CurrentQuestion = 0

func UpdateText():
	get_node("Next").text = "Next"
	if CurrentQuestion == SelectedQuestions.size() - 1:
		get_node("Next").text = "Finish"
	if Flipped == true && CurrentQuestion != SelectedQuestions.size():
		get_node("Label").text = SelectedAnswers[CurrentQuestion]
		get_node("Label2").text = "Answer:"
	elif CurrentQuestion != SelectedQuestions.size():
		get_node("Label").text = SelectedQuestions[CurrentQuestion]
		get_node("Label2").text = "Question:"

func _on_Flip_pressed():
	if Flipped == true:
		Flipped = false
	else:
		Flipped = true
	get_node("AnimationPlayer").play("Flip")

func _on_Next_pressed():
	CurrentQuestion += 1
	Flipped = false
	if CurrentQuestion == SelectedQuestions.size():
		get_parent().get_node("Selecting Practice").BackToLevel()
		queue_free()
	get_node("Back").visible = true
	UpdateText()

func _on_Back_pressed():
	CurrentQuestion -= 1
	Flipped = false
	if CurrentQuestion == 0:
		get_node("Back").visible = false
	else:
		get_node("Back").visible = true
	UpdateText()
