class_name PlayerStats
extends Resource

signal score_changed(new_score: int)
signal coins_changed(new_coins: int)

const save_path : StringName = "res://player_data/save.ini"

var score : float = 0.0 : set = _set_score
var coins : int = 0 : set = _set_coins
var _best_score : int
var _total_coins : int
var save_config : ConfigFile = ConfigFile.new()


func _init() -> void:
	if FileAccess.file_exists(save_path):
		save_config.load(save_path)
		_best_score = save_config.get_value("Player stats", "Best score", 0)
		_total_coins = save_config.get_value("Player stats", "Total coins", 0)
	else:
		save_config = ConfigFile.new()
		save_config.set_value("Player stats", "Best score", 0)
		save_config.set_value("Player stats", "Total coins", 0)
		save_values_to_file()


func _set_score(new_score: float) -> void:
	if int(new_score) != int(score):
		score_changed.emit(int(new_score))
	score = new_score


func _set_coins(new_coins: int) -> void:
	if coins == new_coins:
		return
	coins = new_coins
	coins_changed.emit(coins)


func save_values_to_file() -> void:
	if score > _best_score:
		_best_score = int(score)
	_total_coins += coins
	save_config.set_value("Player stats", "Best score", _best_score)
	save_config.set_value("Player stats", "Total coins", _total_coins)
	save_config.save(save_path)


func get_best_score() -> int:
	return _best_score

func get_total_coins() -> int:
	return _total_coins
