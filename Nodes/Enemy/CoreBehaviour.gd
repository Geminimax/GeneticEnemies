extends "res://Nodes/Enemy/ComponentBehaviour.gd"


var GRID_SIZE = 3
# Declare member variables here. Examples:
# var a = 2
# var b = "text" 
var body
var velocity = Vector2(0,25)

# Called when the node enters the scene tree for the first time.
func _ready():
	body = get_parent().get_parent()
	pass # Replace with function body.
func act(delta = 0):
	move(delta)
	
func move(delta):
	body.global_position += velocity * delta