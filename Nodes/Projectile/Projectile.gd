extends Node2D

signal projectile_spawn
var velocity
export (int) var damage = 1

func _ready():
	$rc.collision_mask = $Hitbox.collision_mask
	set_as_toplevel(true)
	emit_signal("projectile_spawn")
	pass

func move(delta):
	var movement = velocity * delta
	$rc.cast_to = movement
	$rc.force_raycast_update()
	if $rc.is_colliding():
		#global_position = $rc.get_collision_point() 
		$rc.get_collider().get_parent().on_collision()
		on_collision()
	else:
		global_position += movement

func _physics_process(delta):
	move(delta)

func _on_Lifetime_timeout():
	on_timeout()

func on_timeout():
	destroy()
	
func on_collision():
	destroy()

func _on_Hitbox_area_entered(area):
	on_collision()

func destroy():
	queue_free()

func _on_Hitbox_body_entered(body):
	on_collision()
