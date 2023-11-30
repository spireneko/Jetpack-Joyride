class_name Coin
extends Area2D

signal player_entered()

@onready var collision_shape := $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit()
		# hide()
		# collision_shape.set_deferred("disabled", true)
		queue_free()
