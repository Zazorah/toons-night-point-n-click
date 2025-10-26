class_name UITestSquare
extends UIElement

func _ready() -> void:
	var square = ColorRect.new()
	square.size = Vector2(240, 240)
	square.position = Vector2(24, 24)
	square.color = Color.RED
	
	add_child(square)
