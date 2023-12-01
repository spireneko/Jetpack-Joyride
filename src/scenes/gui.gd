class_name GUI
extends CanvasLayer

signal restart_requested()

@onready var _score := $HUD/ScoreContainer/Score as Label
@onready var _coins := $HUD/ScoreContainer/HBoxContainer/Coins as Label
@onready var _pause_menu := $PauseMenu as Control
@onready var _game_over_menu := $GameOverMenu as Control
@onready var _your_score := $GameOverMenu/MarginContainer/VBoxContainer/Scores/YourScore as Label
@onready var _total_coins := $GameOverMenu/MarginContainer/VBoxContainer/Scores/TotalCoins as Label
@onready var _best_score := $GameOverMenu/MarginContainer/VBoxContainer/Scores/BestScore as Label

var player_stats := preload("res://src/resources/player_stats.tres") as PlayerStats


func _ready() -> void:
	player_stats.score_changed.connect(set_score)
	player_stats.coins_changed.connect(set_coins)
	_reset()


func _reset() -> void:
	set_score(0)
	set_coins(0)
	_pause_menu.hide()
	_game_over_menu.hide()


func set_score(new_score: int) -> void:
	_score.text = "%04d M" % new_score


func set_coins(new_coins_score: int) -> void:
	_coins.text = "%04d" % new_coins_score


func call_game_over_menu() -> void:
	_your_score.text = "Your score is: %d" % int(player_stats.score)
	_total_coins.text = "Your total coins: %d" % player_stats.get_total_coins()
	_best_score.text = "The best score is: %d" % player_stats.get_best_score()
	_game_over_menu.show()
	get_tree().paused = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_continue_button_pressed() -> void:
	_pause_menu.hide()
	get_tree().paused = false


func _on_pause_button_pressed() -> void:
	_pause_menu.show()
	get_tree().paused = true


func _on_restart_button_pressed() -> void:
	_reset()
	restart_requested.emit()
	get_tree().paused = false
