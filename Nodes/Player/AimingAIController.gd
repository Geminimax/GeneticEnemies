extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var move_speed = 4
var lerp_weight = 0.12
var cooldown = false
onready var body = get_node("Player")
var moving_direction = 1
var target = null
export (float) var target_range = 4
var ideal_range = 6
var searching_target = false
var current_enemy = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if target != null and target.alive != false:
		var target_core = target.core_instance
		
			
		body.velocity.x = lerp(body.velocity.x,move_speed * moving_direction,lerp_weight) 
		#if(enemy_pos.x = rand_range(get_viewport_rect().size.x - 16,get_viewport_rect().position.x + 16)
		#if(body.global_position.x > target_core.global_position.x - target_range and body.global_position.x < target_core.global_position.x + target_range):
			
		if(!cooldown):
			body.shoot()
			cooldown = true
			$CooldownTimer.start()
		
		if(body.global_position.x > target_core.global_position.x + target_range):
			moving_direction = -1
		elif(body.global_position.x < target_core.global_position.x - target_range):
			moving_direction = 1
		if(body.global_position.x > target_core.global_position.x - ideal_range and body.global_position.x < target_core.global_position.x + ideal_range):
			moving_direction = 0
			
			
		if(target_core.global_position.y > body.global_position.y - 42):
			target = get_next_target()
	elif searching_target == false:
		moving_direction = 0
		$ReactionTimer.start()
		searching_target = true
	else:
		moving_direction = 0
		



func _on_CooldownTimer_timeout():
	cooldown=false

func get_next_target():
	if(target != null and target.alive):
		current_enemy += 1
	else:
		current_enemy = 0
	return find_closest_enemy()

func find_closest_enemy():
	var enemies = get_parent().get_node("EnemySpawner").get_enemies()
	if enemies.empty():
		return null
	return enemies[current_enemy % enemies.size()]

func _on_ReactionTimer_timeout():
	if target == null or target.alive == false:
		target = get_next_target()
		searching_target = false
		
