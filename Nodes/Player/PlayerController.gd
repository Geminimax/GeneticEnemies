extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var move_speed = 4
var lerp_weight = 0.12
var cooldown = false
onready var body = get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if(Input.is_action_pressed("ui_right")):
		body.velocity.x = lerp(body.velocity.x,move_speed,lerp_weight)
	elif(Input.is_action_pressed("ui_left")):
		body.velocity.x = lerp(body.velocity.x,-move_speed,lerp_weight)
	else:
		body.velocity.x = lerp(body.velocity.x,0,lerp_weight)
		
	if(Input.is_action_pressed("ui_up")):
		body.velocity.y = lerp(body.velocity.y,-move_speed,lerp_weight)
	elif(Input.is_action_pressed("ui_down")):
		body.velocity.y = lerp(body.velocity.y,move_speed,lerp_weight)
	else:
		body.velocity.y = lerp(body.velocity.y,0,lerp_weight)
	
	if(Input.is_action_pressed("shoot")):
		if(!cooldown):
			body.shoot()
			cooldown = true
			$CooldownTimer.start()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CooldownTimer_timeout():
	cooldown=false
