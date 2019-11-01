extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity
export (int) var damage = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func move(delta):
	global_position += velocity * delta

func _physics_process(delta):
	move(delta)

func _on_Lifetime_timeout():
	on_timeout()

func on_timeout():
	queue_free()
	
func on_collision():
	queue_free()

func _on_Hitbox_area_entered(area):
	on_collision()
