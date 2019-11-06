extends Node2D

signal death

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
		add_core(randi() % frame_size, randi() % frame_size)
		

func add_core(x,y):
	core_instance = core.instance()
	core_position = Vector2(x,y)
	add_component(x,y, core_instance)
	
func add_component(x,y, instance):
	$Components.add_child(instance)
	instance.global_position = Vector2(x,y) * grid_size
	components[int(x)][int(y)] = instance.name
	component_list.append(instance)
	component_count += 1
	instance.frame = self
	instance.connect("death",self,"on_component_death")
	print(component_count)

func get_empty_spaces():
	var empty_list = []
	for i in range(frame_size):
		for j in range(frame_size):
			if components[i][j] == null:
				empty_list.append(Vector2(i,j))
			else:
				print(components[i][j])
	return empty_list
	
func _on_Timer_timeout():
		if current_component < component_list.size():
			component_list[current_component].act()
			current_component = (current_component + 1) % component_list.size()

func _physics_process(delta):
	if alive:
		time_alive += delta
	global_position += velocity * delta

func on_component_death(component):
	print("Component died!")
	if(component == core_instance):
		print("Core dead!")
		encode_to_genome()
		deactivate()
	component_list.remove(component_list.find(component))
	component.deactivate()

func deactivate():
	set_process(false)
	set_physics_process(false)
	visible = false
	emit_signal("death")

func on_projectile_destroy(minimum_distance):
	#TODO
	print("Projectile destroyed, minimum distance was " + str(minimum_distance))
	
func score_calculation():
	#TODO
	pass

func encode_to_genome():
	var genome = {}
	genome["core"] = core_position
	genome["body"] = []
	for i in range(frame_size):
		for j in range(frame_size):
			if components[i][j] == null:
				genome["body"].append(str(Vector2(i,j)) + "-null")
			else:
				genome["body"].append(str(Vector2(i,j)) + "-" + components[i][j])
	print(genome)
	pass
	