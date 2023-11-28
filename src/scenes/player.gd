class_name Player
extends CharacterBody2D


const SPEED = -1080.0
const MAX_SPEED = 600

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jetpack_button_pressed := false


func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("turn_on_jetpack"):
		is_jetpack_button_pressed = true
	if Input.is_action_just_released("turn_on_jetpack"):
		is_jetpack_button_pressed = false


func _physics_process(delta: float) -> void:
	if is_jetpack_button_pressed:
		velocity.y += SPEED * delta
	else:
		# velocity.y = move_toward(velocity.y, 0, -SPEED / 10)
		velocity.y += gravity * delta
	velocity.y = clampf(velocity.y, -MAX_SPEED, MAX_SPEED)

	move_and_slide()
