class_name MoveLinearComponent
extends Node

@export var node : Node2D
@export var speed : float = 100.0
@export var direction : Vector2

func _physics_process(delta: float) -> void:
	node.position += direction * speed * delta