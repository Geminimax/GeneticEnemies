extends "res://Nodes/Enemy/EnemyComponent.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var component_list = []
var current_component = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func add_component(component):
	$Components.add_child(component)
	component_list.append(component)

func _process(delta):
	act(delta)



func _on_Timer_timeout():
		if current_component < component_list.size():
			component_list[current_component].act()
			current_component = (current_component + 1) % component_list.size()
