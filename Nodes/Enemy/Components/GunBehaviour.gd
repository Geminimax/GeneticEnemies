extends "res://Nodes/Enemy/ComponentBehaviour.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal end_shooting
signal on_cooldown
# Called when the node enters the scene tree for the first time.
export (int) var burst_count = 1
export (PackedScene) var projectile
export (float) var shoot_cooldown = 0.5
export (float) var burst_timer
export (Vector2) var direction = Vector2.DOWN
export (int) var move_speed = 100
var current_burst = 0
var on_cooldown = true
onready var cooldown = $Cooldown
onready var burst = $BurstTimer
export (float) var projectile_angle_variation = 0
export (float) var velocity_random_variation_percent = 0
func _ready():
	cooldown.wait_time = shoot_cooldown
	burst.wait_time = burst_timer
	$InitialCooldown.start(0.1)

func set_frame(value):
	.set_frame(value)
	frame.active_components.append(self)
	connect("end_shooting",frame,"on_end_shooting")

func act(delta = 0):
	if !on_cooldown:
		start_shooting()
	else:
		emit_signal("end_shooting")
func deactivate():
	frame.active_components.erase(self)
	.deactivate()
	
func start_shooting():
	burst.start()
		
func shoot_projectile():
	var proj = projectile.instance()
	var pos = $SpawnPoint
	proj.direction = direction.rotated(deg2rad(rand_range(-projectile_angle_variation,projectile_angle_variation)))
	proj.move_speed = (move_speed * frame.bullet_speed_multi) + frame.velocity.length() 
	proj.time_alive = proj.time_alive * frame.bullet_range_multi * (1 + rand_range(-velocity_random_variation_percent,velocity_random_variation_percent))
	add_child(proj)
	proj.connect("destroy", frame, "on_projectile_destroy")
	proj.connect("player_hit", frame, "on_player_hit")
	proj.global_position = pos.global_position 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Cooldown_timeout():
	on_cooldown = false
	
func _on_BurstTimer_timeout():
	shoot_projectile()
	current_burst += 1
	if(current_burst >= burst_count):
		current_burst = 0
		on_cooldown = true
		cooldown.start()
		emit_signal("end_shooting")
	else:
		burst.start()


func _on_InitialCooldown_timeout():
	on_cooldown = false
