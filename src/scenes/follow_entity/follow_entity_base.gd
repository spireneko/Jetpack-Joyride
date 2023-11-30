@tool
class_name FollowEntity
extends Area2D

@export var _visible_notifier_rect: Rect2 :
	set = _set_visible_notifier_rect

@onready var _visible_on_screen_notifier := $VisibleOnScreenNotifier as VisibleOnScreenEnabler2D

func _set_visible_notifier_rect(new_rect: Rect2):
	_visible_notifier_rect = new_rect
	_visible_on_screen_notifier.rect = new_rect
	notify_property_list_changed()
