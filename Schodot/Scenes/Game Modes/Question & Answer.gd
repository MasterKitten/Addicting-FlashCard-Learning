extends TextureRect

# Variables to see if people should show their answers
var ShowAnswers = false
var Correcto = false
onready var SelectingPrac = get_parent().get_parent().get_node("Selecting Practice")

# Variables used to display the question & answers
var SelectedQuestions = []
var SelectedAnswers = []
var ShuffledAnswers = []

# Used for end display purposes
var RNG = RandomNumberGenerator.new()
var Stop = false
var CorrectAnswers = 0
var WrongAnswers = 0
var TotalAnswers = 0

# Timer to see how long to stay on correct / wrong
var StartTimer = false
var timer = 0

# Make sure the percentage doesn't go over.
var TheBarValue = 0

# Quick variables
onready var TheProgressBar = get_node("ProgressBar")
onready var CorrectScreen = get_node("Win")
onready var IncorrectScreen = get_node("Lose")

export (PackedScene) var HelpMe

func _physics_process(delta):
	if StartTimer == true:
		timer += delta
		TheProgressBar.value += delta
		# if the person got it correct, RAINBOW!
		if get_node("Win").visible == true:
			TheProgressBar.modulate.b = RNG.randf()
			TheProgressBar.modulate.g = RNG.randf()
			TheProgressBar.modulate.r = RNG.randf()
	if TheProgressBar.value >= TheBarValue:
		TheProgressBar.value = TheBarValue
	if timer >= 1:
		# End the correct/wrong
		get_node("Win").visible = false
		get_node("Lose").visible = false
		TheProgressBar.modulate.b = 1
		TheProgressBar.modulate.g = 1
		TheProgressBar.modulate.r = 1
		# help the user understand the word.
		if ShowAnswers == true && Correcto == false:
			var Item = HelpMe.instance()
			get_parent().add_child(Item)
			Item.SelectedAnswer = SelectedAnswers[0]
			Item.SelectedQuestion = SelectedQuestions[0]
			Item.Commanding()
		else:
			# Skip it!
			Correcto = true
		SelectedAnswers.remove(0)
		SelectedQuestions.remove(0)
		# The rest of the code is used to get the ending screen to work.
		if SelectedAnswers.size() != 0 && SelectedQuestions.size() != 0:
			UpdateText()
		timer = 0
		StartTimer = false
	if SelectedAnswers.size() == 0 && SelectedQuestions.size() == 0 && Correcto == true && Stop == true:
		get_node("AnimationPlayer").play("Fade")
		Stop = false
	# Display the variables if the game ended.
	if get_node("Results").visible == true:
		get_node("Results/ProgressBar").value += (delta * (get_node("Results/ProgressBar").max_value) * 0.5)
	if get_node("Results/ProgressBar").value >= CorrectAnswers:
		get_node("Results/ProgressBar").value = CorrectAnswers

func UpdateText():
	RNG.randomize()
	var i = 0
	# Starting thing, sets certain variables
	while i < SelectedAnswers.size() && !Stop:
		ShuffledAnswers.append(SelectedAnswers[i])
		i += 1
		TheProgressBar.max_value = SelectedAnswers.size()
		#Results screen stuff
		TotalAnswers = SelectedAnswers.size()
		get_node("Results/ProgressBar").max_value = SelectedAnswers.size()
	Stop = true
	ShuffledAnswers.shuffle()
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
	TheBarValue += 1
	if get_node("Answer 0" + str(Integer)).text == SelectedAnswers[0]:
		get_node("Win").visible = true
		get_node("AudioCorrect").play()
		CorrectAnswers += 1
		Correcto = true
	if get_node("Answer 0" + str(Integer)).text != SelectedAnswers[0]:
		get_node("Lose").visible = true
		get_node("AudioIncorrect").play()
		WrongAnswers += 1
		Correcto = false
	# see: Process!
	StartTimer = true

# Ending screen stuff
func Finality():
	get_node("Results").visible = true
	get_node("Results/Correct").text = "Correct: " + str(CorrectAnswers)
	get_node("Results/Wrong").text = "Wrong: " + str(WrongAnswers)
	get_node("Results/Progress2").text = str(CorrectAnswers) + " / " + str(TotalAnswers)
	get_node("Music").volume_db = -30

# Go back to main menu
func _on_Continue_pressed():
	get_node("AnimationPlayer").play("FadeOut")

func Back():
	SelectingPrac.BackToLevel()
	queue_free()
