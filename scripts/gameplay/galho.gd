extends AnimatableBody2D
class_name Galho

const PLATFORM_TEXTURE: Texture2D = preload("res://assets/environment/shine_on/platforms/tree_branch.png")
const FOLIAGE_TEXTURES: Array[Texture2D] = [
	preload("res://assets/environment/shine_on/platforms/TreeBranchPlatform5.png"),
	preload("res://assets/environment/shine_on/platforms/TreeBranchPlatform6.png"),
	preload("res://assets/environment/shine_on/platforms/TreeBranchPlatform7.png"),
]
const RESTING_NOOK_TEXTURE: Texture2D = preload("res://assets/environment/shine_on/decoration/mimi_rest_nook.png")

@export var branch_index: int = 0
@export var branch_size: Vector2 = Vector2(130.0, 18.0)
@export var moving: bool = false
@export var movement_amplitude: float = 45.0
@export var movement_speed: float = 0.65
@export var is_goal: bool = false

var base_position: Vector2 = Vector2.ZERO
var movement_phase: float = 0.0


func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	base_position = position
	movement_phase = float(branch_index) * 0.72

	var collision_shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = branch_size
	collision_shape.shape = rectangle
	add_child(collision_shape)
	_create_sprites()


func _physics_process(_delta: float) -> void:
	if moving:
		var time := float(Time.get_ticks_msec()) / 1000.0
		position.x = base_position.x + sin(time * movement_speed + movement_phase) * movement_amplitude


func _create_sprites() -> void:
	_create_foliage()

	var tile_left := -branch_size.x / 2.0
	var remaining_width := branch_size.x
	while remaining_width > 0.0:
		var tile_width := minf(16.0, remaining_width)
		var tile := Sprite2D.new()
		tile.texture = PLATFORM_TEXTURE
		tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		tile.position = Vector2(tile_left + tile_width / 2.0, -5.0)
		tile.scale = Vector2(tile_width / 16.0, branch_size.y / 16.0)
		add_child(tile)
		tile_left += tile_width
		remaining_width -= tile_width

	if is_goal:
		var goal := Sprite2D.new()
		goal.texture = RESTING_NOOK_TEXTURE
		goal.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		goal.position = Vector2(
			0.0,
			-branch_size.y / 2.0 - (RESTING_NOOK_TEXTURE.get_height() - 4.0) / 2.0
		)
		add_child(goal)


func _create_foliage() -> void:
	var tile_left := -branch_size.x / 2.0
	var remaining_width := branch_size.x
	var tile_index := 0
	while remaining_width > 0.0:
		var tile_width := minf(16.0, remaining_width)
		var leaves := Sprite2D.new()
		leaves.texture = FOLIAGE_TEXTURES[(tile_index + branch_index) % FOLIAGE_TEXTURES.size()]
		leaves.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		leaves.position = Vector2(tile_left + tile_width / 2.0, 3.0)
		leaves.scale = Vector2(tile_width / 16.0, 1.0)
		leaves.z_index = -1
		add_child(leaves)
		tile_left += tile_width
		remaining_width -= tile_width
		tile_index += 1
