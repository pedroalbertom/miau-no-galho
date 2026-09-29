extends Node2D
class_name FundoPixel

const CLOUD_2: Texture2D = preload("res://assets/provisorios/Sprites/Cloud2.png")
const CLOUD_3: Texture2D = preload("res://assets/provisorios/Sprites/Cloud3.png")
const HILL_1: Texture2D = preload("res://assets/provisorios/Sprites/Hill1.png")
const HILL_2: Texture2D = preload("res://assets/provisorios/Sprites/Hill2.png")
const BUSH_3: Texture2D = preload("res://assets/provisorios/Sprites/Bush3.png")


func setup(viewport_size: Vector2) -> void:
	var sky := ColorRect.new()
	sky.size = viewport_size
	sky.color = Color("#78b8e8")
	sky.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sky)

	_add_sprite(CLOUD_3, Vector2(viewport_size.x * 0.14, viewport_size.y * 0.20), 3.0)
	_add_sprite(CLOUD_2, Vector2(viewport_size.x * 0.83, viewport_size.y * 0.33), 3.0)
	_add_sprite(HILL_2, Vector2(viewport_size.x * 0.18, viewport_size.y - 58.0), 3.0)
	_add_sprite(HILL_1, Vector2(viewport_size.x * 0.81, viewport_size.y - 46.0), 3.0)
	_add_sprite(BUSH_3, Vector2(viewport_size.x * 0.54, viewport_size.y - 10.0), 3.0)


func _add_sprite(texture: Texture2D, sprite_position: Vector2, sprite_scale: float) -> void:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.position = sprite_position
	sprite.scale = Vector2.ONE * sprite_scale
	add_child(sprite)
