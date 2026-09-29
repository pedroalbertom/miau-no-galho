extends Node2D

const CLOUD_1: Texture2D = preload("res://assets/provisorios/Sprites/Cloud1.png")
const CLOUD_2: Texture2D = preload("res://assets/provisorios/Sprites/Cloud2.png")
const CLOUD_3: Texture2D = preload("res://assets/provisorios/Sprites/Cloud3.png")
const HILL_1: Texture2D = preload("res://assets/provisorios/Sprites/Hill1.png")
const HILL_2: Texture2D = preload("res://assets/provisorios/Sprites/Hill2.png")
const BUSH_2: Texture2D = preload("res://assets/provisorios/Sprites/Bush2.png")


func _ready() -> void:
	var sky := ColorRect.new()
	sky.position = Vector2(-700.0, -1250.0)
	sky.size = Vector2(1400.0, 1750.0)
	sky.color = Color("#78b8e8")
	sky.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sky)

	_add_sprite(CLOUD_3, Vector2(-350.0, -1050.0), 2.5)
	_add_sprite(CLOUD_1, Vector2(330.0, -890.0), 2.5)
	_add_sprite(CLOUD_2, Vector2(-300.0, -650.0), 2.5)
	_add_sprite(CLOUD_3, Vector2(340.0, -420.0), 2.5)
	_add_sprite(CLOUD_1, Vector2(-330.0, -180.0), 2.5)
	_add_sprite(CLOUD_2, Vector2(320.0, 75.0), 2.5)
	_add_sprite(HILL_2, Vector2(-330.0, 305.0), 4.0)
	_add_sprite(HILL_1, Vector2(340.0, 335.0), 4.0)
	_add_sprite(BUSH_2, Vector2(-470.0, 365.0), 3.0)
	_add_sprite(BUSH_2, Vector2(470.0, 365.0), 3.0)


func _add_sprite(texture: Texture2D, sprite_position: Vector2, sprite_scale: float) -> void:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.position = sprite_position
	sprite.scale = Vector2.ONE * sprite_scale
	add_child(sprite)
