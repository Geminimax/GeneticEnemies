extends "res://Nodes/Enemy/ComponentBehaviour.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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

func _ready():
	cooldown.wait_time = shoot_cooldown
	burst.wait_time = burst_timer
	cooldown.start()

func act(delta = 0):
	if !on_cooldown:
		start_shooting()

func start_shooting():
	shoot_projectile()
	current_burst = 1
	on_cooldown = true
	if(current_burst >= burst_count):
		current_burst = 0
		cooldown.start()
	else:
		burst.start()
		
func shoot_projectile():
	var proj = projectile.instance()
	var pos = $SpawnPoint
	proj.direction = direction
	proj.move_speed = move_speed * frame.bullet_speed_multi
	proj.time_alive = proj.time_alive * frame.bullet_range_multi
	add_child(proj)
	proj.connect("destroy", frame, "on_projectile_destroy")
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
		cooldown.start()
	else:
		burst.start()
