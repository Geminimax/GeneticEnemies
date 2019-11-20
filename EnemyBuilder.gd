extends Node
var enemy_frame_scene = preload("res://Nodes/Enemy/EnemyFrame.tscn")
var component_limit = 4
var current_id = 0
export (Array,PackedScene) var components

func _ready():
	pass
	
func build_random():
	randomize()
	var enemy = new_enemy()
	enemy.add_core(randi() % enemy.frame_size, randi() % enemy.frame_size)
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
	
func get_component(index):
	var component = components[index].instance()
	component.id_component = index
	return component
	
func get_random_component():
	var index = random_list_index(components)
	return get_component(index)

func random_in_list(list):
	return list[randi() % list.size()]
func random_list_index(list):
	return randi() % list.size()

func build_from_genes(genome):
	var core_pos = genome["core"]
	var body = genome["body"]
	
	var enemy = new_enemy()
	enemy.add_core(int(core_pos.x),int(core_pos.y))
	
	for i in range(body.size()):
		for j in range(body[0].size()):
			if body[i][j] != -1:
				enemy.add_component(i,j, get_component(body[i][j]))
	return enemy
				