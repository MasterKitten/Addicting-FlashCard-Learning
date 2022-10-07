extends TextureRect

var SelectedQuestions = []
var SelectedAnswers = []
var ShuffledAnswers = []

var RNG = RandomNumberGenerator.new()
var Stop = false

var StartTimer = false
var timer = 0

func _physics_process(delta):
	if StartTimer == true:
		timer += delta
	if timer >= 1:
		get_node("Win").visible = false
		get_node("Lose").visible = false
		StartTimer = false
		timer = 0
		if (SelectedAnswers.size() == 0 && SelectedQuestions.size() == 0):
			get_parent().get_node("Music").play()
			queue_free()
		else:
			UpdateText()

func UpdateText():
	RNG.randomize()
	var i = 0
	while i < SelectedAnswers.size() && !Stop:
		ShuffledAnswers.append(SelectedAnswers[i])
		i += 1
	ShuffledAnswers.shuffle()
	Stop = true
	get_node("Question Text").text = SelectedQuestions[0]
	i = 0
	while true:
		if ShuffledAnswers.size() > i:
			get_node("Answer 0" + str(i)).visible = true
			get_node("Answer 0" + str(i)).text = ShuffledAnswers[i]
		else:
			get_node("Answer 0" + str(i)).visible = false
		if i == 3:
			break
		i += 1
	get_node("Answer 0" + str(RNG.randi_range(0, 0 + i))).text = SelectedAnswers[0]

# when a answer is pressed...
func _on_Answer_pressed(Integer):
	# Programmer, DO SOMETHING WITH THIS!
	if get_node("Answer 0" + str(Integer)).text == SelectedAnswers[0]:
		get_node("Win").visible = true
		get_node("AudioCorrect").play()
		StartTimer = true
	if get_node("Answer 0" + str(Integer)).text != SelectedAnswers[0]:
		get_node("Lose").visible = true
		get_node("AudioIncorrect").play()
		StartTimer = true
	SelectedAnswers.remove(0)
	SelectedQuestions.remove(0)
