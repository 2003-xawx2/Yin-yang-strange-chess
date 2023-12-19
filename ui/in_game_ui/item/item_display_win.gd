extends HBoxContainer


var sprite:Texture:
	set(value):
		$TextureRect.texture = value

var text:
	set(value):
		$Label.text = str(value)
