extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ENEMIES_PER_GENERATION = 5
const BEST_ENEMIES_COUNT = 5
# Called when the node enters the scene tree for the first tim
export (Vector2) var velocity = Vector2()
export (Array,PackedScene) var available_enemies = []
var current_generation = 0 
var generation_enemies = []
var generation_enemy_death_count = 0
var prepared_enemies = []

func _ready():
	initial_generation()

func initial_generation():
	for i in range(ENEMIES_PER_GENERATION):
		prepared_enemies.append(prepare_random_enemy())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += velocity * delta
	if(global_position.x >= get_viewport_rect().size.x):
		velocity = -velocity
	elif(global_position < get_viewport_rect().position):
		velocity = -velocity
#	pass

	
func spawn_enemy(enemy):
	var enemy_pos = global_position
	get_tree().get_root().get_node("Main").add_child(enemy)
	enemy.global_position = enemy_pos
	enemy.connect("death",self,"on_enemy_death")
	generation_enemies.append(enemy)

func prepare_random_enemy():
	return $EnemyBuilder.build_random()

func spawn_next_enemy():
	if(prepared_enemies.empty()):
		print("ERROR! prepared_enemies is empty")
		return
	spawn_enemy(prepared_enemies[0])
	prepared_enemies.remove(0)
	
func _on_SpawnCooldown_timeout():
	spawn_next_enemy()
	
func on_enemy_death():
	generation_enemy_death_count += 1
	if(generation_enemy_death_count == ENEMIES_PER_GENERATION):
		generation_end()

func generation_end():
	#TODO
	generation_enemy_death_count = 0
	apply_evolution()
	print("Generation end!")
	
func apply_evolution():
	var best_enemies = get_best_genes()	
	var pairs = get_enemy_pairs(best_enemies,ENEMIES_PER_GENERATION)
	var new_population_genome = []
	for pair in pairs:
		new_population_genome.append(pair_crossover(pair[0],pair[1]))
	
	prepared_enemies = []
	for genome in new_population_genome:
		prepared_enemies.append($EnemyBuilder.build_from_genes(genome))
	#Apply crossover between enemies 
	pass

func get_enemy_pairs(enemy_list,pair_count):
	var pairs = []
	for i in range(pair_count):
		var list = enemy_list.duplicate(false)
		var index = randi()%list.size()
		var element_one = list[index]
		list.remove(index)
		var element_two = list[randi()%list.size()]
		pairs.append([element_one,element_two])
	return pairs

func pair_crossover(enemy_a,enemy_b):
	var dice = rand_range(0,1)
	var genome = {}
	#Core genome
	var enemy_a_genome = enemy_a.encode_to_genome()
	var enemy_b_genome = enemy_b.encode_to_genome()
	if rand_range(0,1) >= 0.5:
		genome["core"] = enemy_a_genome["core"]
	else:
		genome["core"] = enemy_b_genome["core"]
	
	#Postions
	#Different frame sizes possible??
	genome["body"] = []
	for x in range(enemy_a.frame_size):
		var line = []
		for y in range(enemy_a.frame_size):
			if rand_range(0,1) >= 0.5:
				line.append(enemy_a_genome["body"][x][y])
			else:
				line.append(enemy_b_genome["body"][x][y])
		genome["body"].append(line)
	
	return genome
	
func get_best_genes():
	generation_enemies.sort_custom(self, "sort_enemies")
	var best_enemies = []
	for i in range(BEST_ENEMIES_COUNT):
		best_enemies.append(generation_enemies[generation_enemies.size() - (i + 1)])
	return best_enemies

func sort_enemies(a,b):
	return a.get_score() < b.get_score()