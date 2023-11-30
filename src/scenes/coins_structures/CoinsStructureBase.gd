class_name CoinsStructure
extends Node2D

@onready var _visibility_notifier := $VisibleOnScreenNotifier2D as VisibleOnScreenNotifier2D


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func connect_all_coins(function: Callable) -> void:
	for coin in get_children():
		if coin is Coin:
			coin.player_entered.connect(function)


func get_height() -> float:
	return _visibility_notifier.rect.size.y
