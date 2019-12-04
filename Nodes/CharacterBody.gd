extends KinematicBody2D
export (Vector2) var acceleration = Vector2()
export (int) var angular_acceleration
export (PackedScene) var projectile 

var velocity = Vector2()
var angular_velocity = 0
var angle = 0 

export (Vector2) var max_velocity = Vector2(100,10)
export (float) var max_angular_velocity = 5
var damage_taken = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerTracker.player = self
	pass # Replace with function body.

func _physics_process(delta):
	velocity += acceleration * delta
	
	if abs(velocity.x) > max_velocity.x:
		velocity.x = max_velocity.x * sign(velocity.x)
	if abs(velocity.y) > max_velocity.y:
		velocity.y = max_velocity.y * sign(velocity.y)
	
	angular_velocity += angular_acceleration * delta
	if abs(angular_velocity) > max_angular_velocity:
		angular_velocity = max_angular_velocity * sign(angular_velocity)

	
	angle = int(angle + angular_velocity) % 360
	
	var rotated_velocity = velocity.rotated(deg2rad(angle))
	move_and_collide(rotated_velocity)
	rotation_degrees = angle

func shoot():
	var proj = projectile.instance()
	var pos = $SpawnPoint
	
	get_parent().get_parent().add_child(proj)
	proj.position = pos.global_position 

func _on_Area2D_area_entered(area):
	on_collision()

func on_collision():
	damage_taken += 1
