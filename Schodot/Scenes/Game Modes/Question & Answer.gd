extends TextureRect

var ShowAnswers = false
var SelectedQuestions = []
var SelectedAnswers = []
var ShuffledAnswers = []

var RNG = RandomNumberGenerator.new()
var Stop = false

var StartTimer = false
var timer = 0

var TheBarValue = 0

var CorrectAnswers = 0
var WrongAnswers = 0
var TotalAnswers = 0

onready var TheProgressBar = get_node("ProgressBar")
onready var CorrectScreen = get_node("Win")
onready var IncorrectScreen = get_node("Lose")

func _physics_process(delta):
	if StartTimer == true:
		timer += delta
		TheProgressBar.value += delta
		if get_node("Win").visible == true:
			TheProgressBar.modulate.b = RNG.randf()
			TheProgressBar.modulate.g = RNG.randf()
			TheProgressBar.modulate.r = RNG.randf()
		
	if TheProgressBar.value >= TheBarValue:
		TheProgressBar.value = TheBarValue
	if timer >= 0.9:
		get_node("Win").visible = false
		get_node("Lose").visible = false
		TheProgressBar.modulate.b = 1
		TheProgressBar.modulate.g = 1
		TheProgressBar.modulate.r = 1
		StartTimer = false
		timer = 0
		if SelectedAnswers.size() == 0 && SelectedQuestions.size() == 0:
			get_node("AnimationPlayer").play("Fade")
		else:
			UpdateText()
	
	if get_node("Results").visible == true:
		get_node("Results/ProgressBar").value += (delta * 1.5)
	if get_node("Results/ProgressBar").value >= CorrectAnswers:
		get_node("Results/ProgressBar").value = CorrectAnswers

func UpdateText():
	RNG.randomize()
	var i = 0
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
	# Programmer, DO SOMETHING WITH THIS!
	TheBarValue += 1
	if get_node("Answer 0" + str(Integer)).text == SelectedAnswers[0]:
		get_node("Win").visible = true
		get_node("AudioCorrect").play()
		StartTimer = true
		CorrectAnswers += 1
	if get_node("Answer 0" + str(Integer)).text != SelectedAnswers[0]:
		get_node("Lose").visible = true
		get_node("AudioIncorrect").play()
		StartTimer = true
		WrongAnswers += 1
	if ShowAnswers == true:
		print(SelectedAnswers[0])
	SelectedAnswers.remove(0)
	SelectedQuestions.remove(0)

func Finality():
	get_node("Results").visible = true
	get_node("Results/Correct").text = "Correct: " + str(CorrectAnswers)
	get_node("Results/Wrong").text = "Wrong: " + str(WrongAnswers)
	get_node("Results/Progress2").text = str(CorrectAnswers) + " / " + str(TotalAnswers)
	get_node("Music").volume_db = -30

func _on_Continue_pressed():
	get_parent().get_node("Selecting Practice").BackToLevel()
	queue_free()
