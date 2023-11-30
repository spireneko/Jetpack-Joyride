extends Node

enum RocketTypes { ONE_LOW, ONE_HIGH, ONE_RANDOM, TWO, TWO_RANDOM}
enum CoinsStructureTypes {HEART, RHOMBUS, LINE}

const RocketScn := preload("res://src/scenes/rocket.tscn")
const HeartCoinsStructureScn := preload("res://src/scenes/coins_structures/heart_coins_structure.tscn")
const RhombusCoinsStructureScn := preload("res://src/scenes/coins_structures/rhombus_coins_structure.tscn")
const LineCoinsStructureScn := preload("res://src/scenes/coins_structures/line_coins_structure.tscn")

# Obstacles will be created between those limits
# Limits should be set from World
# X is low limit, Y is high limit
var height_limits : Vector2


func generate_random_obstacle(kill_function: Callable, coins_adder: Callable) -> void:
	generate_rocket(kill_function,
			RocketTypes.values()[randi() % RocketTypes.size()])
	generate_coins_struct(coins_adder,
			CoinsStructureTypes.values()[randi() % CoinsStructureTypes.size()])


func generate_rocket(kill_function: Callable ,rocket_type: RocketTypes = RocketTypes.ONE_LOW) -> void:
	if height_limits == Vector2.ZERO:
		return
	
	var local_height_limits : Vector2 = height_limits + Vector2(-40.0, 50.0)

	var first_new_rocket := RocketScn.instantiate() as Rocket
	match rocket_type:
		RocketTypes.ONE_LOW:
			first_new_rocket.position.y = local_height_limits.x
		RocketTypes.ONE_HIGH:
			first_new_rocket.position.y = local_height_limits.y
		RocketTypes.ONE_RANDOM:
			first_new_rocket.position.y = randf_range(
					local_height_limits.x, local_height_limits.y)
		RocketTypes.TWO:
			var second_new_rocket := RocketScn.instantiate() as Rocket
			first_new_rocket.position.y = local_height_limits.x
			second_new_rocket.position.y = local_height_limits.y
			second_new_rocket.player_entered.connect(kill_function)
			var second_path_follow : PathFollow2D = get_parent().add_to_floor_path(second_new_rocket)
			second_path_follow.add_to_group("rockets")
		RocketTypes.TWO_RANDOM:
			var second_new_rocket := RocketScn.instantiate() as Rocket
			first_new_rocket.position.y = randf_range(
					local_height_limits.x, local_height_limits.y)
			second_new_rocket.position.y = randf_range(
					local_height_limits.x, local_height_limits.y)
			second_new_rocket.player_entered.connect(kill_function)
			var second_path_follow : PathFollow2D = get_parent().add_to_floor_path(second_new_rocket)
			second_path_follow.add_to_group("rockets")

	first_new_rocket.player_entered.connect(kill_function)
	var first_path_follow : PathFollow2D = get_parent().add_to_floor_path(first_new_rocket)
	first_path_follow.add_to_group("rockets")


func generate_coins_struct(function: Callable, type: CoinsStructureTypes = CoinsStructureTypes.HEART) -> void:
	if height_limits == Vector2.ZERO:
		return
	
	var height_limits_margin := 20.0
	var coin_struct : CoinsStructure
	match type:
		CoinsStructureTypes.HEART:
			coin_struct = HeartCoinsStructureScn.instantiate()
		CoinsStructureTypes.RHOMBUS:
			coin_struct = RhombusCoinsStructureScn.instantiate()
		CoinsStructureTypes.LINE:
			coin_struct = LineCoinsStructureScn.instantiate()
	coin_struct.connect_all_coins(function)
	get_parent().add_to_floor_path(coin_struct)
	coin_struct.position.y = randf_range(
			height_limits.x - height_limits_margin - coin_struct.get_height(),
			height_limits.y + height_limits_margin)
	
