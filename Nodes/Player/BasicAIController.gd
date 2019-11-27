extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var move_speed = 4
var lerp_weight = 0.12
var cooldown = false
onready var body = get_node("Player")
var moving_direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	body.velocity.x = lerp(body.velocity.x,move_speed * moving_direction,lerp_weight) 
	#if(enemy_pos.x = rand_range(get_viewport_rect().size.x - 16,get_viewport_rect().position.x + 16)
	if(body.global_position.x > get_viewport_rect().size.x - 16 and moving_direction == 1):
		moving_direction = -1
	elif(body.global_position.x < get_viewport_rect().position.x + 16 and moving_direction == -1):
		moving_direction = 1
		
	if(!cooldown):
		body.shoot()
		cooldown = true
		$CooldownTimer.start()


func _on_CooldownTimer_timeout():
	cooldown=false
