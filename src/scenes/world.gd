extends Node2D

const FloorFragment := preload("res://src/scenes/floor_fragment.tscn")

var game_resolution := Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
var floor_size : Vector2
var ceiling_fragments := []
var floor_fragments := []



func _ready():
	var tmp_fragment := FloorFragment.instantiate() as StaticBody2D
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


func generate_floor(amount_of_fragments: int, is_floor: bool):
	var displacement_coefficient : int = 1
	if is_floor:
		displacement_coefficient = 3
	var tmp_array := []
	for i in range(amount_of_fragments):
		var is_flipping_h := !bool((i + displacement_coefficient) % 3
			&& (i + displacement_coefficient) % 4)
		var is_flipping_v := !bool((i + displacement_coefficient) % 2)
		var new_fragment := FloorFragment.instantiate() as StaticBody2D

		new_fragment.hide()
		add_child(new_fragment)
		new_fragment.position.x = new_fragment.width * i
		if is_floor:
			new_fragment.position.y = game_resolution.y - new_fragment.height
		new_fragment.sprite.flip_h = is_flipping_h
		new_fragment.sprite.flip_v = is_flipping_v
		new_fragment.show()

		tmp_array.append(new_fragment)
	
	return tmp_array
