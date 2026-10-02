extends RefCounted
class_name MimiSprites

const IDLE_FRAMES: Array[Texture2D] = [
	preload("res://assets/characters/mimi/idle/idle_01.png"),
	preload("res://assets/characters/mimi/idle/idle_02.png"),
	preload("res://assets/characters/mimi/idle/idle_03.png"),
	preload("res://assets/characters/mimi/idle/idle_04.png"),
]

const JUMP_FRAMES: Array[Texture2D] = [
	preload("res://assets/characters/mimi/jump/jump_01.png"),
	preload("res://assets/characters/mimi/jump/jump_02.png"),
	preload("res://assets/characters/mimi/jump/jump_03.png"),
]

const DEATH_FRAMES: Array[Texture2D] = [
	preload("res://assets/characters/mimi/death/death_01.png"),
	preload("res://assets/characters/mimi/death/death_02.png"),
	preload("res://assets/characters/mimi/death/death_03.png"),
]


static func create_sprite(animation_name: StringName = &"idle") -> AnimatedSprite2D:
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = create_frames()
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.play(animation_name)
	return sprite


static func create_frames() -> SpriteFrames:
	var frames := SpriteFrames.new()
	if frames.has_animation(&"default"):
		frames.remove_animation(&"default")
	_add_animation(frames, &"idle", IDLE_FRAMES, 5.0, true)
	_add_animation(frames, &"jump", JUMP_FRAMES, 7.0, true)
	_add_animation(frames, &"death", DEATH_FRAMES, 6.0, false)
	return frames


static func _add_animation(
	frames: SpriteFrames,
	animation_name: StringName,
	textures: Array[Texture2D],
	speed: float,
	loop: bool
) -> void:
	frames.add_animation(animation_name)
	frames.set_animation_speed(animation_name, speed)
	var loop_mode := SpriteFrames.LOOP_LINEAR if loop else SpriteFrames.LOOP_NONE
	frames.set_animation_loop_mode(animation_name, loop_mode)
	for texture in textures:
		frames.add_frame(animation_name, texture)
