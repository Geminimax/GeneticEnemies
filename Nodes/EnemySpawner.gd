extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first tim
export (Vector2) var velocity = Vector2()
export (Array,PackedScene) var available_enemies = []
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += velocity * delta
	if(global_position.x >= get_viewport_rect().size.x):
		velocity = -velocity
	elif(global_position < get_viewport_rect().position):
		velocity = -velocity
#	pass

func spawn_random_enemy():
	#var chosen_enemy = available_enemies[randi()%available_enemies.size()]
	var enemy = $EnemyBuilder.build()
	var enemy_pos = global_position
	#
	get_tree().get_root().get_node("Main").add_child(enemy)
	enemy.global_position = enemy_pos
	return 

func _on_SpawnCooldown_timeout():
	spawn_random_enemy()
	pass # Replace with function body.
