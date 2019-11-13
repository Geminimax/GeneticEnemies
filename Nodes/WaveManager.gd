extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ENEMIES_PER_GENERATION = 15
const BEST_ENEMIES_COUNT = 5
# Called when the node enters the scene tree for the first tim
export (Vector2) var velocity = Vector2()
export (Array,PackedScene) var available_enemies = []
var current_generation = 0 
var generation_enemies = []
var generation_enemy_death_count = 0
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
	var enemy = $EnemyBuilder.build_random()
	var enemy_pos = global_position
	#
	get_tree().get_root().get_node("Main").add_child(enemy)
	enemy.global_position = enemy_pos
	enemy.connect("death",self,"on_enemy_death")
	generation_enemies.append(enemy)
	return 

func _on_SpawnCooldown_timeout():
	spawn_random_enemy()
	pass # Replace with function body.
	
func on_enemy_death():
	generation_enemy_death_count += 1
	if(generation_enemy_death_count == ENEMIES_PER_GENERATION):
		generation_end()

func generation_end():
	#TODO
	generation_enemy_death_count = 0
	apply_evolution()
	
func apply_evolution():
	var best_enemies = get_best_genes()
	
	pass

func pairwise_crossover(enemy_a,enemy_b):
	#TODO
	pass
	
func get_best_genes():
	generation_enemies.sort_custom(self, "sort_enemies")
	var best_enemies = []
	for i in range(BEST_ENEMIES_COUNT):
		best_enemies.append(generation_enemies[generation_enemies.size() - (i + 1)])
	return best_enemies

func sort_enemies(a,b):
	return a.get_score() < b.get_score()