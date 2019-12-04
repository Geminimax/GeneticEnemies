extends Node2D

signal death(component)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var hp = 1
var frame
var id_component
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in $Behaviour.get_children():
		child.frame = frame
		child.initialize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func act(delta = 0):
	for child in $Behaviour.get_children():
		child.act(delta)

func deactivate():
	for child in $Behaviour.get_children():
		child.deactivate()
	call_deferred("queue_free")


func _on_Area2D_area_entered(area):
	on_collision()

func on_collision():
	hp -= 1
	frame.times_hit += 1
	if hp <= 0:
		emit_signal("death",self)