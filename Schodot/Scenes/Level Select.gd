extends TextureRect

onready var Practice = get_parent().get_node("Selecting Practice")

func _on_Spanish_pressed():
	_on_FileDialog_file_selected("res://Pre-made Cards/Tower 01")

func _on_Select_Custom_pressed():
	get_node("FileDialog").popup()

func _on_FileDialog_file_selected(path):
	# I am too lazy to improve code
	var save_game = File.new()
	if not save_game.file_exists(path):
		print("Error! Save does not exist!")
		return # Error! We don't have a save to load.
		
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open(path, File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		if node_data.Groups.size() != 0 && node_data.Answers[0].size() != 0 && node_data.Questions[0].size() != 0:
			Practice.Populate(node_data)
			get_node("AnimationPlayer").play("Slide")
		else:
			print("Not big enough!")
	save_game.close()
