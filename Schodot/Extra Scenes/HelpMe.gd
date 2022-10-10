extends ColorRect

export (String) var SelectedAnswer
export (String) var SelectedQuestion
var QuestionCommands = ["Testing1", "Testing2", "Testing3"]
var AnswerCommands = ["Toosting1", "Toosing2", "Toosting3"]

# Do you want to memorize!!?? DO YOU WANT TO MEMORIZE!!???
export (int) var AmountOfSaying = 5
var i = 0

var Music = AudioServer.get_bus_index("Music")
var AudioLevel = db2linear(AudioServer.get_bus_volume_db(Music))

func Commanding():
	AudioServer.set_bus_volume_db(Music, linear2db(-0.25))
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
		Commanding()
		i += 1
	else:
		# Go back to the game.
		AudioServer.set_bus_volume_db(Music, linear2db(AudioLevel))
		get_parent().get_node("Question & Answer").Correcto = true
		queue_free()
