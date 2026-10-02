extends CharacterBody2D
class_name Mimi

const MIMI_SPRITES = preload("res://scripts/gameplay/mimi_sprites.gd")

signal charge_changed(amount: float)
signal jump_started
signal landed(branch_index: int)
signal fell

@export_group("Salto")
@export var min_vertical_power: float = 320.0
@export var max_vertical_power: float = 580.0
@export var min_horizontal_power: float = 65.0
@export var max_horizontal_power: float = 260.0
@export var max_charge_time := 1.0
@export var charge_curve_power: float = 1.0
@export var landing_friction: float = 1600.0
@export var fall_limit := 520.0
@export_group("")

var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
var facing: int = 1
var charging: bool = false
var charge_time: float = 0.0
var previous_jump_down: bool = false
var control_enabled: bool = true
var fall_reported: bool = false
var last_landed_branch: int = -1
var esp32_input: Node

@onready var sprite: AnimatedSprite2D = $Sprite2D


func _ready() -> void:
	esp32_input = get_tree().current_scene.get_node_or_null("ControleESP32")
	collision_layer = 1
	collision_mask = 2
	sprite.sprite_frames = MIMI_SPRITES.create_frames()
	sprite.play(&"idle")
	_update_sprite()


func _physics_process(delta: float) -> void:
	if not control_enabled:
		return

	var jump_down := _is_action_down("jump")
	var on_floor := is_on_floor()

	if on_floor:
		velocity.y = 0.0
		velocity.x = move_toward(velocity.x, 0.0, landing_friction * delta)
		if not charging:
			_read_facing()
			if jump_down and not previous_jump_down:
				charging = true
				charge_time = 0.0
				AudioMiau.play_sfx("click")

		if charging:
			charge_time = min(charge_time + delta, max_charge_time)
			charge_changed.emit(charge_time / max_charge_time)
			if not jump_down and previous_jump_down:
				_launch_jump()
	else:
		velocity.y += gravity * delta

	move_and_slide()
	_check_landing()
	_update_sprite()

	if global_position.y > fall_limit and not fall_reported:
		fall_reported = true
		control_enabled = false
		fell.emit()

	previous_jump_down = jump_down


func _read_facing() -> void:
	var left_down := _is_action_down("left")
	var right_down := _is_action_down("right")
	if left_down and not right_down:
		facing = -1
	elif right_down and not left_down:
		facing = 1


func _launch_jump() -> void:
	var raw_strength: float = clampf(charge_time / max_charge_time, 0.0, 1.0)
	# A curva de potência deixa toques curtos realmente fracos e preserva a força máxima.
	var strength: float = pow(raw_strength, charge_curve_power)
	var vertical_power: float = lerpf(min_vertical_power, max_vertical_power, strength)
	var horizontal_power: float = lerpf(min_horizontal_power, max_horizontal_power, strength)
	velocity = Vector2(float(facing) * horizontal_power, -vertical_power)
	charging = false
	charge_time = 0.0
	charge_changed.emit(0.0)
	jump_started.emit()
	AudioMiau.play_sfx("jump")


func _check_landing() -> void:
	if not is_on_floor():
		return

	for collision_index in get_slide_collision_count():
		var collision := get_slide_collision(collision_index)
		var collider := collision.get_collider()
		if collider is Galho:
			var branch: Galho = collider
			if branch.branch_index != last_landed_branch:
				last_landed_branch = branch.branch_index
				landed.emit(branch.branch_index)
				AudioMiau.play_sfx("land")


func set_control_enabled(enabled: bool) -> void:
	control_enabled = enabled
	if not enabled:
		velocity = Vector2.ZERO


func _is_action_down(action_name: String) -> bool:
	if Input.is_action_pressed(action_name):
		return true
	return esp32_input != null and esp32_input.has_method("is_action_pressed") and esp32_input.is_action_pressed(action_name)


func _update_sprite() -> void:
	var animation_name: StringName = &"idle" if is_on_floor() else &"jump"
	if sprite.animation != animation_name:
		sprite.play(animation_name)
	sprite.flip_h = facing < 0
