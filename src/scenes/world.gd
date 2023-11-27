extends Node2D

const FloorFragment := preload("res://src/scenes/floor_fragment.tscn")

# @onready var floor_path := $FloorPath as Path2D
# @onready var path_follow := $FloorPath/PathFollow2D as PathFollow2D

var game_resolution := Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
var floor_size : Vector2
var ceiling_fragments := []
var floor_fragments := []



func _ready():
	var tmp_fragment := FloorFragment.instantiate() as Sprite2D
	tmp_fragment.hide()
	add_child(tmp_fragment)
	floor_size = Vector2(
		tmp_fragment.width,
		tmp_fragment.height
	)
	tmp_fragment.queue_free()

	var amount_of_fragments : int = game_resolution.x / floor_size.x + 5
	ceiling_fragments = generate_floor(amount_of_fragments, false)
	floor_fragments = generate_floor(amount_of_fragments, true)

	# Create ceiling collision
	var body := StaticBody2D.new()
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
	add_child(body)

	#

	# floor_path.position = game_resolution
	# floor_path.curve.set_point_position(0, Vector2((amount_of_fragments - 1) * floor_size.x, 0))
	# floor_path.curve.set_point_position(1, Vector2(-floor_size.x, 0))


func _physics_process(delta: float) -> void:
	# path_follow.h_offset += Globals.WORLD_SPEED * delta
	pass


func generate_floor(amount_of_fragments: int, is_floor: bool):
	var displacement_coefficient : int = 1
	if is_floor:
		displacement_coefficient = 3
	var tmp_array := []
	for i in range(amount_of_fragments):
		var is_flipping_h := !bool((i + displacement_coefficient) % 3
			&& (i + displacement_coefficient) % 4)
		var is_flipping_v := !bool((i + displacement_coefficient) % 2)
		var new_fragment := FloorFragment.instantiate() as Sprite2D

		new_fragment.hide()
		# path_follow.add_child(new_fragment)
		new_fragment.position.x = new_fragment.width * i
		if is_floor:
			new_fragment.position.y = game_resolution.y - new_fragment.height
		new_fragment.flip_h = is_flipping_h
		new_fragment.flip_v = is_flipping_v
		new_fragment.move_linear_component.speed = Globals.WORLD_SPEED
		new_fragment.move_linear_component.direction = Vector2.LEFT
		new_fragment.show()

		tmp_array.append(new_fragment)
	
	return tmp_array
