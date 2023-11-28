extends Node

enum RocketTypes { ONE_LOW, ONE_HIGH, ONE_RANDOM, TWO, TWO_RANDOM}

const RocketScn = preload("res://src/scenes/rocket.tscn")

# Obstacles will be created between those limits
# Limits should be set from World
# X is low limit, Y is high limit
var height_limits : Vector2


func generate_random_obstacle() -> void:
	generate_rocket(RocketTypes.values()[randi() % RocketTypes.size()])


func generate_rocket(rocket_type: RocketTypes = RocketTypes.ONE_LOW) -> void:
	if height_limits == Vector2.ZERO:
		return
	
	var local_height_limits = height_limits + Vector2(-40.0, 50.0)

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
			var second_new_rocket := RocketScn.instantiate()
			first_new_rocket.position.y = local_height_limits.x
			second_new_rocket.position.y = local_height_limits.y
			var second_path_follow : PathFollow2D = get_parent().add_to_floor_path(second_new_rocket)
			second_path_follow.add_to_group("rockets")
		RocketTypes.TWO_RANDOM:
			var second_new_rocket := RocketScn.instantiate()
			first_new_rocket.position.y = randf_range(
					local_height_limits.x, local_height_limits.y)
			second_new_rocket.position.y = randf_range(
					local_height_limits.x, local_height_limits.y)
			var second_path_follow : PathFollow2D = get_parent().add_to_floor_path(second_new_rocket)
			second_path_follow.add_to_group("rockets")

	var first_path_follow : PathFollow2D = get_parent().add_to_floor_path(first_new_rocket)
	first_path_follow.add_to_group("rockets")
