class_name Player
extends CharacterBody2D

const SPEED = -1080.0
const MAX_SPEED = 600

@onready var left_jetpack_particles := $LeftJetpackParticles as GPUParticles2D
@onready var right_jetpack_particles := $RightJetpackParticles as GPUParticles2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jetpack_button_pressed := false

func _ready() -> void:
	reset()


func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("turn_on_jetpack"):
		is_jetpack_button_pressed = true
		left_jetpack_particles.emitting = true
		right_jetpack_particles.emitting = true
	if Input.is_action_just_released("turn_on_jetpack"):
		is_jetpack_button_pressed = false
		left_jetpack_particles.emitting = false
		right_jetpack_particles.emitting = false


func _physics_process(delta: float) -> void:
	if is_jetpack_button_pressed:
		velocity.y += SPEED * delta
	else:
		velocity.y += gravity * delta
	velocity.y = clampf(velocity.y, -MAX_SPEED, MAX_SPEED)

	move_and_slide()


func reset() -> void:
	is_jetpack_button_pressed = false
	left_jetpack_particles.emitting = false
	right_jetpack_particles.emitting = false
	velocity = Vector2.ZERO