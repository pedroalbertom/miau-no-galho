extends Node2D

const TOTAL_BRANCHES := 15
const PHASE_START_Y: float = 268.0
const PHASE_GOAL_Y: float = -899.0

@onready var mimi: Mimi = $Mimi
@onready var hud: HUDMiau = $HUDMiau

var start_time: int = 0
var elapsed_time: float = 0.0
var jump_count: int = 0
var finished: bool = false

var branch_specs: Array[Dictionary] = [
	{"position": Vector2(0.0, 300.0), "width": 220.0, "moving": false},
	{"position": Vector2(140.0, 215.0), "width": 155.0, "moving": false},
	{"position": Vector2(-130.0, 130.0), "width": 150.0, "moving": false},
	{"position": Vector2(35.0, 45.0), "width": 145.0, "moving": false},
	{"position": Vector2(-120.0, -40.0), "width": 140.0, "moving": false},
	{"position": Vector2(85.0, -125.0), "width": 135.0, "moving": false},
	{"position": Vector2(-80.0, -210.0), "width": 130.0, "moving": false},
	{"position": Vector2(120.0, -295.0), "width": 130.0, "moving": false},
	{"position": Vector2(-110.0, -380.0), "width": 125.0, "moving": false},
	{"position": Vector2(15.0, -465.0), "width": 120.0, "moving": false},
	{"position": Vector2(150.0, -550.0), "width": 120.0, "moving": false},
	{"position": Vector2(0.0, -635.0), "width": 120.0, "moving": false},
	{"position": Vector2(-140.0, -720.0), "width": 112.0, "moving": true},
	{"position": Vector2(30.0, -805.0), "width": 108.0, "moving": true},
	{"position": Vector2(0.0, -890.0), "width": 105.0, "moving": true},
]


func _ready() -> void:
	_create_branches()
	start_time = Time.get_ticks_msec()
	mimi.landed.connect(_on_player_landed)
	mimi.fell.connect(_on_player_fell)
	mimi.charge_changed.connect(_on_charge_changed)
	mimi.jump_started.connect(_on_jump_started)
	hud.set_jump_count(jump_count)
	hud.set_phase_progress(0.0)
	AudioMiau.play_music()


func _process(_delta: float) -> void:
	if finished:
		return

	elapsed_time = float(Time.get_ticks_msec() - start_time) / 1000.0
	hud.set_time(elapsed_time)
	var phase_progress: float = clampf((PHASE_START_Y - mimi.position.y) / (PHASE_START_Y - PHASE_GOAL_Y), 0.0, 1.0)
	hud.set_phase_progress(phase_progress)

	if mimi.global_position.y > mimi.fall_limit:
		_on_player_fell()


func _create_branches() -> void:
	for index in branch_specs.size():
		var spec: Dictionary = branch_specs[index]
		var branch := Galho.new()
		branch.branch_index = index
		branch.branch_size = Vector2(float(spec["width"]), 18.0)
		branch.moving = bool(spec["moving"])
		branch.movement_amplitude = 42.0 + float(index - 12) * 5.0
		branch.movement_speed = 0.58 + float(index - 12) * 0.08
		branch.is_goal = index == TOTAL_BRANCHES - 1
		branch.position = spec["position"]
		$Galhos.add_child(branch)


func _on_player_landed(branch_index: int) -> void:
	if branch_index == TOTAL_BRANCHES - 1:
		_finish(true)


func _on_charge_changed(amount: float) -> void:
	hud.set_charge(amount)


func _on_jump_started() -> void:
	jump_count += 1
	hud.set_jump_count(jump_count)


func _on_player_fell() -> void:
	_finish(false)


func _finish(victory: bool) -> void:
	if finished:
		return
	finished = true
	mimi.set_control_enabled(false)
	if victory:
		AudioMiau.play_sfx("win")
	else:
		AudioMiau.play_sfx("fall")

	await get_tree().create_timer(0.9).timeout
	if victory:
		get_tree().change_scene_to_file("res://scenes/vitoria.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/derrota.tscn")
