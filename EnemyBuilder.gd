extends Node
var enemy_frame_scene = preload("res://Nodes/Enemy/EnemyFrame.tscn")
var component_limit = 4
var current_id = 0
export (Array,PackedScene) var components

func _ready():
	pass
	
func build():
	randomize()
	var enemy = new_enemy()
	enemy.global_position = Vector2(100,0)
	var empty_spaces = enemy.get_empty_spaces()
	while(empty_spaces.size() > 0 and enemy.component_count < component_limit):
		var position = random_in_list(empty_spaces)
		var component = get_random_component()
		enemy.add_component(position.x,position.y, component)
		empty_spaces = enemy.get_empty_spaces()
	return enemy

func new_enemy():
	var enemy = enemy_frame_scene.instance()
	enemy.initialize()
	return enemy

func get_random_component():
	return random_in_list(components).instance()

func random_in_list(list):
	return list[randi() % list.size()]