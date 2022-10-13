extends TextureRect

var SelectedQuestions = []
var SelectedAnswers = []
var ShowAnswers = false

var timer = 0
var StartTimer = false
export(Texture) var Check
export(Texture) var Err

var Correct = false

# Display stuff before going back to not displaying anything
func _process(delta):
	if StartTimer == true:
		timer += delta
	if timer >= 2.5:
		StartTimer = false
		timer = 0
		get_node("LineEdit").editable = true
		UpdateText()

func AudioPlay():
	if Correct == true:
		get_node("Ding").play()
	else:
		get_node("Wrong").play()

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
	# This one line stops bugs.
	if get_node("LineEdit").editable == true:
		# If correct, good. Otherwise, no. Also show wrong answer when applicable.
		if SelectedAnswers[0].to_lower() == new_text.to_lower():
			get_node("Correct?").text = "Correct!"
			get_node("Mark").texture = Check
			Correct = true
		else:
			get_node("Correct?").text = "Wrong!"
			get_node("Mark").texture = Err
			Correct = false
		if ShowAnswers == true:
			get_node("Answer").text = "Answer: " + SelectedAnswers[0]
		else:
			get_node("Answer").text = ""
		get_node("LineEdit").editable = false
		SelectedAnswers.remove(0)
		SelectedQuestions.remove(0)
		get_node("AnimationPlayer").play("RESET")
		StartTimer = true
