extends Control

# The variables
var Name
onready var AnswerGroup = get_node("Answer Group/Answer")
onready var QuestionGroup = get_node("Question Group/Questions")
onready var Group = get_node("Groups/Groups")

# Stuff that is used during and after loading/saving
export (Array, Array, String) var Questions
export (Array, Array, String) var Answers
export (Array, String) var Groups
var ShowAnswer = false

# Instance variables.
export (PackedScene) var Butt
var SelectedGroup = -1
export (PackedScene) var Labell
var SelectedLabel = -1

var SaveToDev = false

# Open saving with a button press
func _on_Save_pressed():
	if !SaveToDev:
		get_node("Saving Stuffs/FileDialog").popup()
	else:
		get_node("Saving Stuffs/DeveloperFile").popup()

# From the Godot Tutorial.
func save():
	var save_dict = {
		"Questions" : Questions,
		"Answers" : Answers,
		"Groups" : Groups,
		"ShowAnswer" : ShowAnswer,
	}
	return save_dict

# Heavily modified from the Godot tutorial
func save_game():
	var save_game = File.new()
	save_game.open(Name, File.WRITE)
	var save_node = self
	
	# Check the node has a save function.
	# Call the node's save function.
	var node_data = save_node.call("save")
	# Store the save dictionary as a new line in the save file.
	save_game.store_line(to_json(node_data))
	save_game.close()

# when a file is selected...
func _on_FileDialog_file_selected(path):
	Name = path
	save_game()

#LOADING BELOW!

# open loading with a button press
func _on_Load_pressed():
	if !SaveToDev:
		get_node("Saving Stuffs/FileDialog2").popup()
	else:
		get_node("Saving Stuffs/DeveloperFile2").popup()

# When the file to load is selected...
func _on_FileDialog2_file_selected(path):
	Name = path
	load_game()

func load_game():
	# I am too lazy to improve code, so here is a datas variable
	var datas
	var save_game = File.new()
	if not save_game.file_exists(Name):
		print("Error! Save does not exist!")
		return # Error! We don't have a save to load.
	
	# What does this do? When loading another file, we have to remove EVERYTHING!
	var Answerss = AnswerGroup.get_children()
	var i = 0
	while i < Answers.size():
		Answers.remove(i)
		i = 0
	i = 0
	while i < Answerss.size():
		Answerss[i].queue_free()
		i += 1
	var Questionss = QuestionGroup.get_children()
	i = 0
	while i < Questions.size():
		Questions.remove(i)
		i = 0
	i = 0
	while i < Questionss.size():
		Questionss[i].queue_free()
		i += 1
	var Groupss = Group.get_children()
	i = 0
	while i != Groups.size():
		Groups.remove(i)
		i = 0
	i = 0
	while i < Groupss.size():
		Groupss[i].queue_free()
		i += 1
		
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open(Name, File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		datas = node_data
	save_game.close()
	
	# Load everything in the creation section
	i = 0
	while i < datas.Groups.size():
		var Item = Butt.instance()
		Item.text = datas.Groups[i]
		Item.ItemThing = i
		Groups.append(Item.text)
		Group.add_child(Item)
		Answers.append([])
		Questions.append([])
		i += 1
	i = 0
	SelectedGroup = 0
	# Loading in the Questions & Answers in the group.
	while SelectedGroup < datas.Groups.size():
		i = 0
		while i < datas.Questions[SelectedGroup].size():
			Questions[SelectedGroup].append(datas.Questions[SelectedGroup][i])
			i += 1
		i = 0
		while i < datas.Answers[SelectedGroup].size():
			Answers[SelectedGroup].append(datas.Answers[SelectedGroup][i])
			i += 1
		SelectedGroup += 1
	SelectedGroup = -1
	# ShowAnswer loading
	if datas.ShowAnswer == true:
		get_node("Saving Stuffs/ShowAnswer").pressed = true
	else:
		get_node("Saving Stuffs/ShowAnswer").pressed = false
	
	# Changing the text
	get_node("Selected Group").text = "Done! Select A Group!"
	get_node("Selected Items").text = "Selected Input: "

# Massive seperation from the saving part :D
# -----------------------------------------------------------------------------------------------------------
# Just making sure

func _on_LineEdit_text_entered(new_text):
	var Item = Butt.instance()
	Group.add_child(Item);
	Item.text = new_text
	Item.ItemThing = Groups.size()
	Groups.append(new_text)
	Questions.append([])
	Answers.append([])
	get_node("Make Group").text = ""

func _on_Question_text_entered(new_text):
	if SelectedGroup != -1:
		var Item = Labell.instance()
		var Items = QuestionGroup.get_children()
		Item.ItemThing = Items.size()
		QuestionGroup.add_child(Item)
		Item.text = str(Item.ItemThing + 1) + ". " + new_text
		Questions[SelectedGroup].append(new_text)
		get_node("Question").text = ""
	else:
		print("Select a group!")

func _on_Answer_text_entered(new_text):
	if SelectedGroup != -1:
		var Item = Labell.instance()
		var Items = AnswerGroup.get_children()
		Item.ItemThing = Items.size()
		AnswerGroup.add_child(Item)
		Item.text = str(Item.ItemThing + 1) + ". " + new_text
		Answers[SelectedGroup].append(new_text)
		get_node("Answer").text = ""
	else:
		print("Select a group!")

# Used for the buttons. This isn't a indivudual function because of it being different to save_game()
func Pingas():
	# Remove everything
	var Answerss = AnswerGroup.get_children()
	for i in Answerss:
		i.queue_free()
	var Questionss = QuestionGroup.get_children()
	for i in Questionss:
		i.queue_free()
	
	# Is there nothing?
	if Nothing():
		return
	
	# When changing groups, we have to redo the entire list.
	var i = 0
	while i < Questions[SelectedGroup].size():
		var Item = Labell.instance()
		QuestionGroup.add_child(Item)
		Item.text = str(i + 1) + ". " + Questions[SelectedGroup][i]
		Item.ItemThing = i
		i += 1
	i = 0
	while i < Answers[SelectedGroup].size():
		var Item = Labell.instance()
		AnswerGroup.add_child(Item)
		Item.text = str(i + 1) + ". " + Answers[SelectedGroup][i]
		Item.ItemThing = i
		i += 1

# This function checks for nothing. Returns true if there is, in fact, nothing
func Nothing():
	if Questions.size() == 0 && Answers.size() == 0:
		return true
	if Questions[SelectedGroup].size() == 0 && Answers[SelectedGroup].size() == 0:
		return true

# ------------------------------------------------------------------------------------------------------------

func _on_Delete_Group_pressed():
	# if a group is selected...
	if (SelectedGroup != -1):
		# Remove it!
		Groups.remove(SelectedGroup)
		Answers.remove(SelectedGroup)
		Questions.remove(SelectedGroup)
		# So my code broke somehow, and this was the solution.
		for x in Group.get_children():
			x.queue_free()
		var i = 0
		while i < Groups.size():
			var Item = Butt.instance()
			Item.text = Groups[i]
			Item.ItemThing = i
			Group.add_child(Item)
			i += 1
		i = 0
	else:
		print("Select A Group!")

func _on_Delete_Item_pressed():
	# if the array sizes are the same...
	if Questions[SelectedGroup].size() == Answers[SelectedGroup].size():
		#... and we have a selected label...
		if SelectedLabel != -1:
			var Ans = AnswerGroup.get_children()
			var Ques = QuestionGroup.get_children()
			Answers[SelectedGroup].remove(SelectedLabel)
			Questions[SelectedGroup].remove(SelectedLabel)
			Ans[SelectedLabel].queue_free()
			Ques[SelectedLabel].queue_free()
			var i = 0
			# Setting numbers
			while (i < Ans.size()):
				Ans[i].ItemThing = i - 1
				i += 1
			i = 0
			while (i < Ques.size()):
				Ques[i].ItemThing = i - 1
				i += 1
		else:
			print("Select A Label!")
	else:
		print("Even the Questions & Answers!")
	Pingas()

# This goes back to the main menu
func _on_Quit_pressed():
	var _nill = get_tree().change_scene("res://Defaults/Main Scene.tscn")

func _on_Open_Movement_pressed():
	get_node("Movement Dialog").popup()

# these are the variables that are controlled by the window above.
var BeforeGroup = 0
var AfterGroup = 0
var BeforeItem = 0
var AfterItem = 0

func _on_Change_Group_pressed():
	if Nothing():
		return
	# This looks like a mess. You want to know why? I had to do a work-around because Godot doesn't like multiple arrays?
	var Items = Group.get_children()
	var Tempo = Groups[BeforeGroup - 1]
	var TempName = Items[BeforeGroup - 1].text
	var TempName2 = Items[AfterGroup - 1].text
	# Doing stuff
	Groups[BeforeGroup - 1] = Groups[AfterGroup - 1]
	Groups[AfterGroup - 1] = Tempo
	Groups[AfterGroup - 1] = TempName
	Groups[BeforeGroup - 1] = TempName2
	Items[AfterGroup - 1].text = TempName
	Items[BeforeGroup - 1].text = TempName2
	SelectedGroup = AfterGroup - 1
	
	# Switching Answer & Question Lists
	var Temp = Answers[BeforeGroup - 1]
	var Temp2 = Questions[BeforeGroup - 1]
	Answers[BeforeGroup - 1] = Answers[AfterGroup - 1]
	Questions[BeforeGroup - 1] = Questions[AfterGroup - 1]
	Answers[AfterGroup - 1] = Temp
	Questions[AfterGroup - 1] = Temp2
	Pingas()
	# Set text of the stuffs
	get_node("Movement Dialog/GroupThing").text = ""
	get_node("Movement Dialog/ToGroupThing").text = ""
	get_node("Selected Group").text = "Selected Group: " + Groups[AfterGroup - 1]
	get_node("Selected Items").text = "Selected Input: "

func _on_Change_Item_pressed():
	if Nothing():
		return
	
	if SelectedGroup != -1:
		var Temp = Answers[SelectedGroup][BeforeItem - 1]
		var Temp2 = Questions[SelectedGroup][BeforeItem - 1]
		Answers[SelectedGroup][BeforeItem - 1] = Answers[SelectedGroup][AfterItem - 1]
		Questions[SelectedGroup][BeforeItem - 1] = Questions[SelectedGroup][AfterItem - 1]
		Answers[SelectedGroup][AfterItem - 1] = Temp
		Questions[SelectedGroup][AfterItem - 1] = Temp2
		var i = 0
		var Items = AnswerGroup.get_children()
		while i < AnswerGroup.get_child_count():
			Items[i].text = str(i + 1) + ". " + Answers[SelectedGroup][i]
			i += 1
		i = 0
		Items = QuestionGroup.get_children()
		while i < QuestionGroup.get_child_count():
			Items[i].text = str(i + 1) + ". " + Questions[SelectedGroup][i]
			i += 1
		
		get_node("Movement Dialog/ItemThing").text = ""
		get_node("Movement Dialog/ToItemThing").text = ""

func _on_GroupThing_text_changed(new_text):
	BeforeGroup = int(new_text)

func _on_ToGroupThing_text_changed(new_text):
	AfterGroup = int(new_text)

func _on_ItemThing_text_changed(new_text):
	BeforeItem = int(new_text)

func _on_ToItemThing_text_changed(new_text):
	AfterItem = int(new_text)

func _on_Checking_toggled(button_pressed):
	SaveToDev = button_pressed

func _on_ShowAnswer_toggled(button_pressed):
	ShowAnswer = button_pressed
