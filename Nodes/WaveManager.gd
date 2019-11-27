extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var ENEMIES_PER_GENERATION = 10
export (int) var ELITISM_COUNT = 2
export (int) var TOURNAMENT_SIZE = 4
# Called when the node enters the scene tree for the first tim
export (Vector2) var velocity = Vector2()
export (Array,PackedScene) var available_enemies = []
var current_generation = 0
var generation_enemies = []
var generation_enemy_death_count = 0 
var prepared_enemies = []
var mutation_chance = 0.05

func _ready():
	print("Starting run")
	print("Mutation chance is :" + str(mutation_chance))
	print("Population size:" + str(ENEMIES_PER_GENERATION))
	print("Elitist individual count:" + str(ELITISM_COUNT))
	initial_generation()
	update_generation_display()

func initial_generation():
	for i in range(ENEMIES_PER_GENERATION):
		prepared_enemies.append(prepare_random_enemy())

# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func spawn_enemy(enemy):
	var enemy_pos = Vector2()
	enemy_pos.x = rand_range(get_viewport_rect().size.x - 24,get_viewport_rect().position.x + 24)
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
	print("GENERATION " + str(current_generation) + " END!") 
	for enemy in generation_enemies:
		print("ID : " +  str(enemy.enemy_id) + " Fitness : " + str(enemy.get_score()))
	print("AVERAGE FITNESS IS:" + str(get_total_fitness() / generation_enemies.size()))
	generation_enemy_death_count = 0
	$WaveDelay.start()
	
	
func apply_evolution():
	var elitist_enemies = get_best_genes(ELITISM_COUNT,generation_enemies)
	var pairs = get_enemy_pairs(generation_enemies,ENEMIES_PER_GENERATION - ELITISM_COUNT)
	var new_population_genome = elitist_enemies
	
	for pair in pairs:
		new_population_genome.append(pair_crossover(pair[0],pair[1]))
	
	prepared_enemies = []
	for genome in new_population_genome:
		prepared_enemies.append($EnemyBuilder.build_from_genes(genome))
	#Apply crossover between enemies 
	pass

func get_enemy_pairs(enemy_list,pair_count):
	var pairs = []
	var total_fitness = get_total_fitness()
	for i in range(pair_count):
		pairs.append(select_pair(enemy_list,total_fitness))
	return pairs

func get_total_fitness():
	var score = 0
	for enemy in generation_enemies:
		score += enemy.get_score()
	return score

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
	
	#Mutation
	apply_mutation(genome,mutation_chance)
	return genome
	
func apply_mutation(genome,chance):
	for x in range(genome["body"].size()):
		for y in range(genome["body"][x].size()):
			if rand_range(0,1) <= chance:
				genome["body"][x][y] = $EnemyBuilder.get_random_component_index()

func select_pair(enemy_list, total_fitness):
	var enemy1 = tournament_selection(enemy_list,total_fitness)
	var enemy2 = tournament_selection(enemy_list,total_fitness)
	return [enemy1,enemy2]

func roulette_wheel_selection(enemy_list,total_fitness):
	var current_total = 0
	var goal_value = rand_range(0,total_fitness)
	var current_enemy_index = 0
	
	while current_total < goal_value:
		current_total += enemy_list[current_enemy_index].get_score()
		current_enemy_index += 1
	return enemy_list[current_enemy_index - 1]

func tournament_selection(enemy_list,total_fitness):
	var tournament_list = enemy_list.duplicate()
	tournament_list = select_random_from_list(TOURNAMENT_SIZE,tournament_list)
	return get_best_genes(1,tournament_list)[0]
	

func select_random_from_list(amount,list):
	var random_list = []
	for i in range(amount):
		var index = randi()%list.size()
		random_list.append(list[index])
		list.remove(index)
	return random_list

func get_best_genes(count,list):
	list.sort_custom(self, "sort_enemies")
	var best_enemies = []
	for i in range(count):
		best_enemies.append(list[list.size() - (i + 1)].encode_to_genome())
	return best_enemies

func sort_enemies(a,b):
	return a.get_score() < b.get_score()

func _on_WaveDelay_timeout():
	apply_evolution()
	for enemy in generation_enemies:
		enemy.queue_free()
	generation_enemies = []
	current_generation += 1
	update_generation_display()
	

func update_generation_display():
	$CanvasLayer/RichTextLabel.text = "Generation " + str(current_generation)

func get_enemies():
	var enemies = []
	for enemy in generation_enemies:
		if enemy.alive:
			enemies.append(enemy)
	return enemies