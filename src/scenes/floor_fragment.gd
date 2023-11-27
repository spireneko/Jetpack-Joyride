extends Sprite2D


var width : int : get = _get_width
var height : int : get = _get_height


func _get_width() -> int:
	return texture.get_width()


func _get_height() -> int:
	return texture.get_height()
