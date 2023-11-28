class_name Rocket
extends Area2D

signal player_entered()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
