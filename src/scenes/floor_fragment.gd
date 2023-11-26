extends StaticBody2D

@onready var sprite := $Sprite2D as Sprite2D

var width : int : get = _get_width
var height : int : get = _get_height


func _get_width() -> int:
	return sprite.texture.get_width()


func _get_height() -> int:
	return sprite.texture.get_height()
