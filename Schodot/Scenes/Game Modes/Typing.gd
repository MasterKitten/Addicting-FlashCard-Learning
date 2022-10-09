extends TextureRect

var SelectedQuestions = []
var SelectedAnswers = []

func UpdateText():
	if SelectedQuestions.size() == 0 && SelectedAnswers.size() == 0:
		get_parent().get_node("Selecting Practice").BackToLevel()
		queue_free()
	else:
		get_node("Question").text = SelectedQuestions[0]
	get_node("LineEdit").text = ""

func _on_LineEdit_text_entered(new_text):
	if SelectedAnswers[0].to_lower() == new_text.to_lower():
		get_node("Correct?").text = "Correct!"
	else:
		get_node("Correct?").text = "Wrong!"
	get_node("Answer").text = "Answer: " + SelectedAnswers[0]
	SelectedAnswers.remove(0)
	SelectedQuestions.remove(0)
	UpdateText()
