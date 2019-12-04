extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_scene = "res://Scenes/PlayMain.tscn"
var simple_test = "res://Scenes/TestMainStupid.tscn"
var aiming_test = "res://Scenes/TestMain.tscn"
var spawner
# Called when the node enters the scene tree for the first time.
func _ready():
	seed(498321)
	$Control/Panel/VBoxContainer/MutationRateValue.bbcode_text ="[center]" +  str($Control/Panel/VBoxContainer/MutationRate.value)
	initialize_selection_button()
	initialize_ai_button()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func initialize_selection_button():
	var button = $Control/Panel/VBoxContainer/Selection
	button.add_item("Tournament")
	button.add_item("Roulette")
	pass

func initialize_ai_button():
	var button = $Control/Panel/VBoxContainer/AI
	button.add_item("Player")
	button.add_item("Simple")
	button.add_item("Aiming")
	button.select(2)
	pass
func _on_MutationRate_value_changed(value):
	$Control/Panel/VBoxContainer/MutationRateValue.bbcode_text = "[center]" + str(value)


func _process(delta):
	if Input.is_action_just_pressed("save"):
		var directory = "C:\\Users\\Pichau\\Desktop\\PocTests\\"
		var filename_id = "test_" + str(OS.get_unix_time()) + ".txt"
		spawner.output_data(directory + filename_id)
func _on_Start_pressed():
	var ai_button = $Control/Panel/VBoxContainer/AI
	var scene
	if ai_button.selected == 0:
		scene = load(player_scene)
	elif ai_button.selected == 1:
		scene = load(simple_test)
	else:
		scene = load(aiming_test)
	var instanced_scene = scene.instance()
	var spawner_node = instanced_scene.get_node("EnemySpawner")
	spawner_node.mutation_chance = $Control/Panel/VBoxContainer/MutationRate.value
	spawner_node.ENEMIES_PER_GENERATION = int($Control/Panel/VBoxContainer/PopulationSize.text)
	var selection_button = $Control/Panel/VBoxContainer/Selection
	if selection_button.selected == 0:
		spawner_node.selection = spawner_node.selectionType.TOURNAMENT
	else:
		spawner_node.selection = spawner_node.selectionType.ROULETTE
	$Control.visible = false
	add_child(instanced_scene)
	spawner_node.start()
	spawner = spawner_node
	pass # Replace with function body.
