extends Node2D
signal death
const DISTANCES_CYCLE_SIZE = 5
const SHOOT_SCORE_WEIGHT = 10
const TIME_ALIVE_SCORE_WEIGHT = 2
const SHOOT_SCORE_DIST_DECAY_POWER = 2
const COMPONENT_COUNT_SCORE_WEIGTH = 50
const PLAYER_HIT_SCORE_WEIGHT = 1
var grid_size = 8
var core = preload("res://Nodes/Enemy/EnemyCore.tscn")
var components = []
var component_list = []
var current_component = 0
var core_position 
var component_count = 0
var core_instance
var velocity = Vector2(0,30)
var time_alive = 0
var alive = true
var distances = []
var enemy_id
var player_hit_count = 0
#DONT CHANGE THESE NAMES BRO!
var bullet_range_multi = 1
var bullet_speed_multi = 1
var cycle_speed_multi = 1
var active_components = []
var times_hit = 0
export (int) var frame_size = 4

func init_matrix(width,height):
	var matrix = []
	for i in range(height):
		var line = []
		for j in range(width):
			line.append(null)
		matrix.append(line)
	return matrix

func initialize():
	components = init_matrix(frame_size,frame_size)
		
	
func add_core(x,y):
	core_instance = core.instance()
	core_position = Vector2(x,y)
	$Components.add_child(core_instance)
	core_instance.position = core_position * grid_size
	core_instance.frame = self
	component_list.append(core_instance)
	core_instance.connect("death",self,"on_core_death")
	
func add_component(x,y, instance):
	if(Vector2(x,y) == core_position):
		components[int(x)][int(y)] = instance.id_component
		return
	
	$Components.add_child(instance)
	instance.position = Vector2(x,y) * grid_size
	components[int(x)][int(y)] = instance.id_component
	component_list.append(instance)
	component_count += 1
	instance.frame = self
	instance.connect("death",self,"on_component_death")

func get_empty_spaces():
	var empty_list = []
	for i in range(frame_size):
		for j in range(frame_size):
			if components[i][j] == null and Vector2(i,j) != core_position :
				empty_list.append(Vector2(i,j))
	return empty_list
	
func on_end_shooting():
	$GlobalCooldown.start()
	
func _physics_process(delta):
	if alive:
		time_alive += delta
	global_position += velocity * delta

func on_component_death(component):
	var index = component_list.find(component)
	if index != -1:
		component_list.remove(index)
	#component_list.erase(component)
	component.deactivate()

func on_core_death(component):
	death()
	
func death():
	$GlobalCooldown.stop()
	for i in range(component_list.size() - 1, -1, -1):
		on_component_death(component_list[i])
	component_list = []
	deactivate()


func deactivate():
	$GlobalCooldown.stop()
	
	set_process(false)
	set_physics_process(false)
	#visible = false
	if(alive):
		emit_signal("death")
		alive = false
	
func on_projectile_destroy(minimum_distance):
	if(distances.size() < DISTANCES_CYCLE_SIZE):
		distances.append(minimum_distance)
	else:
		if(minimum_distance < distances[DISTANCES_CYCLE_SIZE - 1]):
			distances[DISTANCES_CYCLE_SIZE -1] = minimum_distance 
	distances.sort()
	
func get_score():
	var score = time_alive_score() + proj_distance_score() + alive_components_score() 
	
	return score

func alive_components_score():
	return (component_list.size() / component_count) * COMPONENT_COUNT_SCORE_WEIGTH * (1 - 1/max(pow(times_hit,3),1))
	
func proj_distance_score():
	var total_value = 0
	for dist in distances:
		total_value += SHOOT_SCORE_WEIGHT/pow(dist,SHOOT_SCORE_DIST_DECAY_POWER)
	return total_value + (PLAYER_HIT_SCORE_WEIGHT*player_hit_count)

func time_alive_score():
	return time_alive * TIME_ALIVE_SCORE_WEIGHT

func encode_to_genome():
	var genome = {}
	genome["core"] = core_position
	genome["body"] = []
	for i in range(frame_size):
		var line = []
		for j in range(frame_size):
			if components[i][j] == null:
				line.append(-1)
			else:
				line.append(components[i][j])
		genome["body"].append(line)
	return genome
	

func _on_VisibilityNotifier2D_screen_exited():
	deactivate()


func _on_GlobalCooldown_timeout():
	activate_next_component()
func on_cooldown():
	activate_next_component()
func get_component_concentration():
	var concentration = {}
	var value
	for i in range(frame_size):
		var line = []
		for j in range(frame_size):
			if components[i][j] == null:
				value = -1
			else:
				value = (components[i][j])
			if concentration.has(value):
					concentration[value] += 1
			else:
				concentration[value] = 1
	return concentration
	
func activate_next_component():
	if !active_components.empty():
		current_component = current_component % active_components.size()
		active_components[current_component].act()
		current_component = (current_component + 1) % active_components.size()
	else:
		$GlobalCooldown.start()
	
func on_player_hit():
	player_hit_count += 1