extends Node2D

const FloorFragment := preload("res://src/scenes/floor_fragment.gd")
const FloorFragmentScn := preload("res://src/scenes/floor_fragment.tscn")
const ObstaclesGenerator := preload("res://src/world/ObstaclesGenerator.gd")
const WorldFollow := preload("res://src/world/WorldFollow.gd")

@onready var gui := $GUI as GUI
@onready var player := $Player as Player
@onready var spawn_obstacle_timer := $SpawnObstacleTimer as Timer
@onready var accelerate_world_timer := $AccelerateWorldTimer as Timer

var player_stats := preload("res://src/resources/player_stats.tres") as PlayerStats
var floor_path : Path2D
var game_resolution := Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
var floor_size : Vector2
var obstacles_generator : ObstaclesGenerator
var starting_player_pos : Vector2


func _ready() -> void:
	starting_player_pos = player.position

	# Calculate fragment size
	var tmp_fragment := FloorFragmentScn.instantiate() as FloorFragment
	floor_size = Vector2(
		tmp_fragment.width,
		tmp_fragment.height
	)
	tmp_fragment.free()

	# Count sufficent amount of fragments to fill the screen
	var amount_of_fragments : int = game_resolution.x / floor_size.x + 7

	# Create Path2D that fragments will follow
	floor_path = Path2D.new()
	floor_path.position.y = game_resolution.y / 2
	floor_path.curve = Curve2D.new()
	floor_path.curve.add_point(Vector2((amount_of_fragments - 3) * floor_size.x, 0))
	floor_path.curve.add_point(Vector2(-floor_size.x * 3, 0))
	add_child(floor_path)

	# Create fragments and attach them to floor_path
	_generate_floor(amount_of_fragments, false)
	_generate_floor(amount_of_fragments, true)

	# Create StaticBody2D for floor and ceiling collisions
	var body := StaticBody2D.new()
	add_child(body)

	# Create ceiling collision
	var ceiling_collision := CollisionShape2D.new()
	ceiling_collision.shape = RectangleShape2D.new()
	ceiling_collision.shape.size = Vector2(
		amount_of_fragments * floor_size.x,
		floor_size.y
	)
	ceiling_collision.position = Vector2(
		ceiling_collision.shape.size.x / 2,
		floor_size.y / 2 + (game_resolution.y - floor_size.y)
	)
	body.add_child(ceiling_collision)

	# Create floor collision
	var floor_collision := CollisionShape2D.new()
	floor_collision.shape = RectangleShape2D.new()
	floor_collision.shape.size = Vector2(
		amount_of_fragments * floor_size.x,
		floor_size.y
	)
	floor_collision.position = Vector2(
		floor_collision.shape.size.x / 2,
		floor_size.y / 2
	)
	body.add_child(floor_collision)

	# Instantiate ObstacleGenerator that will create foes and obstacles
	obstacles_generator = ObstaclesGenerator.new()
	obstacles_generator.height_limits = Vector2(
		game_resolution.y / 2 - floor_size.y,
		-game_resolution.y / 2 + floor_size.y
	)
	add_child(obstacles_generator)


func _physics_process(delta: float) -> void:
	get_tree().call_group("moving_with_world", "add_to_progress", delta)
	player_stats.score += (Globals.world_speed / Globals.WORLD_SPEED_BASE) * delta


func _reset() -> void:
	Globals.world_speed = Globals.WORLD_SPEED_BASE
	player_stats.score = 0.0
	player_stats.coins = 0
	player.position = starting_player_pos
	accelerate_world_timer.start()
	spawn_obstacle_timer.start()
	player.reset()
	get_tree().call_group("not_resetable", "queue_free")


func _generate_floor(amount_of_fragments: int, is_floor: bool) -> void:
	var displacement_coefficient : int = 1
	if is_floor:
		displacement_coefficient = 3
	for i in range(amount_of_fragments):
		var is_flipping_h := !bool((i + displacement_coefficient) % 3
			&& (i + displacement_coefficient) % 4)
		var is_flipping_v := !bool((i + displacement_coefficient) % 2)

		var new_fragment := FloorFragmentScn.instantiate() as FloorFragment
		if is_floor:
			new_fragment.position.y = game_resolution.y / 2 - floor_size.y
		else:
			new_fragment.position.y = -game_resolution.y / 2
		new_fragment.flip_h = is_flipping_h
		new_fragment.flip_v = is_flipping_v
		var path_follow := add_to_floor_path(new_fragment, true)
		path_follow.progress = new_fragment.width * i


# If you want something to move from left to right
# with Globals.world_speed that is the right choice
func add_to_floor_path(node: Node2D, is_resetable: bool = false) -> PathFollow2D:
	var new_path_follow := PathFollow2D.new()
	new_path_follow.set_script(WorldFollow)
	new_path_follow.rotates = false
	new_path_follow.add_to_group("moving_with_world")
	new_path_follow.add_child(node)
	node.tree_exited.connect(new_path_follow._on_child_free)
	floor_path.add_child(new_path_follow)
	if !is_resetable:
		new_path_follow.add_to_group("not_resetable")
	return new_path_follow


func _on_spawn_obstacle_timer_timeout() -> void:
	obstacles_generator.generate_random_obstacle(_kill_player, _increment_coins)
	# obstacles_generator.generate_coins_struct()
	# obstacles_generator.generate_rocket()


func _on_accelerate_world_timer_timeout() -> void:
	Globals.world_speed += Globals.WORLD_SPEED_BASE


func _increment_coins() -> void:
	player_stats.coins += 1


func _kill_player() -> void:
	player_stats.save_values_to_file()
	gui.call_game_over_menu()

func _on_gui_restart_requested() -> void:
	_reset()
