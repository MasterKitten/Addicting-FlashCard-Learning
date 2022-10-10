extends TextureRect

var SelectedQuestions = []
var SelectedAnswers = []
var ShowAnswers = false

var timer = 0
var StartTimer = false

func _process(delta):
	if StartTimer == true:
		timer += delta
	if timer >= 2:
		StartTimer = false
		timer = 0
		get_node("LineEdit").editable = true
		UpdateText()

func UpdateText():
	if SelectedQuestions.size() == 0:
		get_parent().get_node("Selecting Practice").BackToLevel()
		queue_free()
	else:
		get_node("Question").text = SelectedQuestions[0]
	get_node("LineEdit").text = ""
	get_node("Correct?").text = ""
	get_node("Answer").text = ""

func _on_LineEdit_text_entered(new_text):
	if get_node("LineEdit").editable == true:
		if SelectedAnswers[0].to_lower() == new_text.to_lower():
			get_node("Correct?").text = "Correct!"
		else:
			get_node("Correct?").text = "Wrong!"
		if ShowAnswers == true:
			get_node("Answer").text = "Answer: " + SelectedAnswers[0]
		else:
			get_node("Answer").text = ""
		get_node("LineEdit").editable = false
		SelectedAnswers.remove(0)
		SelectedQuestions.remove(0)
		StartTimer = true
