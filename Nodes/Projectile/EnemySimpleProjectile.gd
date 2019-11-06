extends "res://Nodes/Projectile/SimpleProjectile.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal destroy(minimum_distance)
var minimum_distance_to_player = -1
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = PlayerTracker.player 
	pass # Replace with function body.

func _process(delta):
	var distance_to_player = global_position.distance_to(player.global_position)
	if (distance_to_player < minimum_distance_to_player) or minimum_distance_to_player == -1:
		minimum_distance_to_player = distance_to_player 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func destroy():
	emit_signal("destroy",minimum_distance_to_player)
	.destroy()