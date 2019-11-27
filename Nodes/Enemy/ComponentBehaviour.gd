extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var frame setget set_frame
func initialize():
	pass
func act(delta = 0):
	pass

func deactivate():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_frame(value):
	frame = value