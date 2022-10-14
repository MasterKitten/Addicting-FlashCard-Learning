extends ColorRect

export (String) var SelectedAnswer
export (String) var SelectedQuestion
var QuestionCommands = ["Look up to the sky and say it!", "What does this mean!?", "Look to the ground and say this!", 
"Look to your right and say it!", "Imagine a goldfish saying this word!", "Say this out loud!", "Write this down 3 times!", 
"Write this in BOLD"]
var AnswerCommands = ["What does this mean!?", "Look to your right and say this!", "Point to a object and say it!", 
"Bounce and say this once!", "Look at the time and say this!", "Write this down 3 times!", "Imagine this word!", "Write this in Italics!"]

# Do you want to memorize!!?? DO YOU WANT TO MEMORIZE!!???
export (int) var AmountOfSaying = 6
var i = 0

var Music = AudioServer.get_bus_index("Music")
var AudioLevel = db2linear(AudioServer.get_bus_volume_db(Music))

func _process(_delta):
	if !get_node("LearningTime").is_playing():
		get_node("LearningTime").play("Blow-up")

func Commanding():
	AudioServer.set_bus_volume_db(Music, linear2db(0.20))
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	if RNG.randi_range(0, 1) == 1:
		get_node("Command").text = QuestionCommands[RNG.randi_range(0, QuestionCommands.size() - 1)]
		get_node("Answer").text = SelectedQuestion
	else:
		get_node("Command").text = AnswerCommands[RNG.randi_range(0, AnswerCommands.size() - 1)]
		get_node("Answer").text = SelectedAnswer

func _on_Continue_pressed():
	if i < AmountOfSaying:
		get_node("TeacherAnim").play("Change-Thing")
		i += 1
	else:
		# Go back to the game.
		AudioServer.set_bus_volume_db(Music, linear2db(AudioLevel))
		get_parent().get_node("Question & Answer").Correcto = true
		queue_free()
