extends Node2D

const FloorFragment := preload("res://src/scenes/floor_fragment.gd")
const FloorFragmentScn := preload("res://src/scenes/floor_fragment.tscn")

var floor_path : Path2D
var game_resolution := Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
var floor_size : Vector2


func _ready():
	# Calculate fragment size
	var tmp_fragment := FloorFragmentScn.instantiate() as FloorFragment
	floor_size = Vector2(
		tmp_fragment.width,
		tmp_fragment.height
	)
	tmp_fragment.free()

	# Count sufficent amount of fragments to fill the screen
	var amount_of_fragments : int = game_resolution.x / floor_size.x + 5

	# Create Path2D that fragments will follow
	floor_path = Path2D.new()
	floor_path.position.y = game_resolution.y / 2
	floor_path.curve = Curve2D.new()
	floor_path.curve.add_point(Vector2((amount_of_fragments - 1) * floor_size.x, 0))
	floor_path.curve.add_point(Vector2(-floor_size.x, 0))
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


func _physics_process(delta: float) -> void:
	var moing_with_world_group := get_tree().get_nodes_in_group("moving_with_world")
	for node in moing_with_world_group:
		if "progress" in node:
			node.progress += Globals.world_speed * delta



func _generate_floor(amount_of_fragments: int, is_floor: bool):
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
		var path_follow := add_to_floor_path(new_fragment)
		path_follow.progress = new_fragment.width * i


# If you want something to move from left to right
# with Globals.world_speed that is the right choice
func add_to_floor_path(node: Node2D) -> PathFollow2D:
	var new_path_follow := PathFollow2D.new()
	new_path_follow.add_to_group("moving_with_world")
	new_path_follow.add_child(node)
	floor_path.add_child(new_path_follow)
	return new_path_follow
