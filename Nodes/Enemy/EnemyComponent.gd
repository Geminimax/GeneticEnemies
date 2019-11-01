extends Node2D

signal death(component)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var hp = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func act(delta = 0):
	for child in $Behaviour.get_children():
		child.act(delta)



func _on_Area2D_area_entered(area):
	hp -= 1
	if hp <= 0:
		emit_signal("death",self)
