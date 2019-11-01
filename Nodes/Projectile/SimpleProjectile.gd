extends "res://Nodes/Projectile/Projectile.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var move_speed
export (Vector2) var direction
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity  = direction * move_speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
