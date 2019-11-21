extends Node2D
signal death
const DISTANCES_CYCLE_SIZE = 5
const SHOOT_SCORE_WEIGHT = 10
const TIME_ALIVE_SCORE_WEIGHT = 0.75
const SHOOT_SCORE_DIST_DECAY_POWER = 2

var grid_size = 8
var core = preload("res://Nodes/Enemy/EnemyCore.tscn")
var components = []
var component_list = []
var current_component = 0
var core_position 
var component_count = 0
var core_instance
var velocity = Vector2(0,40)
var time_alive = 0
var alive = true
var distances = []

#DONT CHANGE THESE NAMES BRO!
var bullet_range_multi = 1
var bullet_speed_multi = 1
var cycle_speed_multi = 1

export(float) var cycle_base_time = 0.3

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
		

func _ready():
	$Timer.start(cycle_base_time * cycle_speed_multi)
	
func add_core(x,y):
	core_instance = core.instance()
	core_position = Vector2(x,y)
	$Components.add_child(core_instance)
	core_instance.global_position = core_position * grid_size
	core_instance.frame = self
	core_instance.connect("death",self,"on_component_death")
	
func add_component(x,y, instance):
	if(Vector2(x,y) == core_position):
		return
	
	$Components.add_child(instance)
	instance.global_position = Vector2(x,y) * grid_size
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
	
func _on_Timer_timeout():
	if !component_list.empty():
		current_component = current_component % component_list.size()
		component_list[current_component].act()
		current_component = (current_component + 1) % component_list.size()
	$Timer.start(cycle_base_time * cycle_speed_multi)

func _physics_process(delta):
	if alive:
		time_alive += delta
	global_position += velocity * delta

func on_component_death(component):
	if(component == core_instance):
		death()
	else:
		component_list.remove(component_list.find(component))
	component.deactivate()

func death():
	for component in component_list:
		on_component_death(component)
	encode_to_genome()
	deactivate()


func deactivate():
	set_process(false)
	set_physics_process(false)
	visible = false
	emit_signal("death")


func on_projectile_destroy(minimum_distance):
	if(distances.size() < DISTANCES_CYCLE_SIZE):
		distances.append(minimum_distance)
	else:
		if(minimum_distance < distances[DISTANCES_CYCLE_SIZE - 1]):
			distances[DISTANCES_CYCLE_SIZE -1] = minimum_distance 
	distances.sort()
	
func get_score():
	var score = time_alive_score() + proj_distance_score()
	print("Score is :" + str(score))
	return score

func proj_distance_score():
	var total_value = 0
	for dist in distances:
		total_value += SHOOT_SCORE_WEIGHT/pow(dist,SHOOT_SCORE_DIST_DECAY_POWER)
	return total_value

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
	print("Out of screen!")
	death()
