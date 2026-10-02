extends Node2D

const FOREST_BACKGROUNDS: Array[Texture2D] = [
	preload("res://assets/environment/shine_on/background/forest_bg_02.png"),
	preload("res://assets/environment/shine_on/background/forest_bg_03.png"),
	preload("res://assets/environment/shine_on/background/forest_bg.png"),
	preload("res://assets/environment/shine_on/background/forest_bg_05.png"),
	preload("res://assets/environment/shine_on/background/forest_bg_06.png"),
	preload("res://assets/environment/shine_on/background/forest_bg_07.png"),
]


func _ready() -> void:
	var sky := ColorRect.new()
	sky.position = Vector2(-1440.0, -1440.0)
	sky.size = Vector2(2880.0, 2880.0)
	sky.color = Color("#17141f")
	sky.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sky)

	for row in range(6):
		var background_index: int = clampi(5 - row, 0, FOREST_BACKGROUNDS.size() - 1)
		for column in range(3):
			_add_sprite(
				FOREST_BACKGROUNDS[background_index],
				Vector2((float(column) - 1.0) * 960.0, (float(row) - 2.5) * 480.0),
				Vector2(2.0, 2.0),
				column != 1
			)


func _add_sprite(texture: Texture2D, sprite_position: Vector2, sprite_scale: Vector2, flipped: bool) -> void:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.position = sprite_position
	sprite.scale = sprite_scale
	sprite.flip_h = flipped
	add_child(sprite)
