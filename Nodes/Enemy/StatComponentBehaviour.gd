extends "res://Nodes/Enemy/ComponentBehaviour.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String,"bullet_range_multi","bullet_speed_multi","cycle_speed_multi") var stat = "bullet_range_multi"
export (float) var amount = 0.1
# Called when the node enters the scene tree for the first time.
func initialize():
	var stat_value = frame.get(stat)
	frame.set(stat, stat_value + amount)


func deactivate():
	var stat_value = frame.get(stat)
	frame.set(stat, stat_value - amount)
	queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
