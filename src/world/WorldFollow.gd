extends PathFollow2D

func _on_child_free() -> void:
	queue_free()


func add_to_progress(delta: float) -> void:
	if self.is_in_group("rockets"):
		progress += delta * (Globals.world_speed + Globals.ROCKET_SPEED)
	else:
		progress += delta * Globals.world_speed