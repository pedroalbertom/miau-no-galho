extends Node2D
class_name FundoPixel

const FOREST_BACKGROUND: Texture2D = preload("res://assets/environment/shine_on/background/forest_bg.png")


func setup(viewport_size: Vector2) -> void:
	var backdrop := ColorRect.new()
	backdrop.size = viewport_size
	backdrop.color = Color("#17141f")
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)

	var forest := Sprite2D.new()
	forest.texture = FOREST_BACKGROUND
	forest.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	forest.position = viewport_size / 2.0
	forest.scale = Vector2.ONE * 2.25
	add_child(forest)
