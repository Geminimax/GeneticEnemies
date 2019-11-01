extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grid_size = 8
export (int) var frame_size = 4
var core = preload("res://Nodes/Enemy/EnemyCore.tscn")
var components = []
var component_list = []
var current_component = 0
var core_position 
var component_count = 0
var core_instance
var velocity = Vector2(0,40)
# Called when the node enters the scene tree for the first time.
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
	add_component(x,y, core_instance)
	
func add_component(x,y, instance):
	$Components.add_child(instance)
	instance.global_position = Vector2(x,y) * grid_size
	components[int(x)][int(y)] = instance
	component_list.append(instance)
	component_count += 1
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	global_position += velocity * delta

func on_component_death(component):
	print("Component died!")
	if(component == core_instance):
		print("Core dead!")
		queue_free()
	component_list.remove(component_list.find(component))
	component.queue_free()
