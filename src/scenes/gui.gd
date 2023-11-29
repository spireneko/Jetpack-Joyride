class_name GUI
extends CanvasLayer

@onready var _score := $HUD/ScoreContainer/Score as Label
@onready var _coins := $HUD/ScoreContainer/HBoxContainer/Coins as Label
@onready var _pause_button := $HUD/PauseContainer/PauseButton as Button


func set_score(new_score: int):
	_score.text = "%04d M" % new_score


func set_coins(new_coins_score: int):
	_coins.text = "%04d" % new_coins_score
