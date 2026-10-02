extends CanvasLayer
class_name HUDMiau

const PIXEL_FONT: FontFile = preload("res://assets/ui/fonts/pixelify_sans.ttf")

var jump_label: Label
var time_label: Label
var charge_bar: ProgressBar
var height_progress_bar: ProgressBar


func _ready() -> void:
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	var viewport_size := get_viewport().get_visible_rect().size
	var top_bar := ColorRect.new()
	top_bar.position = Vector2(18.0, 18.0)
	top_bar.size = Vector2(viewport_size.x - 36.0, 54.0)
	top_bar.color = Color("#1c2038")
	root.add_child(top_bar)

	jump_label = _create_label(root, "PULOS 0", Vector2(34.0, 31.0), Vector2(170.0, 28.0), 24, Color("#ffffff"))
	time_label = _create_label(root, "00:00", Vector2(viewport_size.x - 195.0, 31.0), Vector2(160.0, 28.0), 24, Color("#ffffff"))
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	height_progress_bar = ProgressBar.new()
	height_progress_bar.position = Vector2(viewport_size.x - 44.0, 136.0)
	height_progress_bar.size = Vector2(28.0, 296.0)
	height_progress_bar.fill_mode = ProgressBar.FILL_BOTTOM_TO_TOP
	height_progress_bar.max_value = 100.0
	height_progress_bar.show_percentage = false
	height_progress_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var height_background := StyleBoxFlat.new()
	height_background.bg_color = Color("#171322")
	height_background.border_color = Color("#f8d99a")
	height_background.set_border_width_all(2)
	var height_fill := StyleBoxFlat.new()
	height_fill.bg_color = Color("#ffd36e")
	height_progress_bar.add_theme_stylebox_override("background", height_background)
	height_progress_bar.add_theme_stylebox_override("fill", height_fill)
	root.add_child(height_progress_bar)

	charge_bar = ProgressBar.new()
	charge_bar.position = Vector2((viewport_size.x - 300.0) / 2.0, viewport_size.y - 49.0)
	charge_bar.size = Vector2(300.0, 24.0)
	charge_bar.max_value = 100.0
	charge_bar.show_percentage = false
	charge_bar.visible = false
	charge_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bar_background := StyleBoxFlat.new()
	bar_background.bg_color = Color(0.10, 0.08, 0.16, 0.88)
	bar_background.border_color = Color("#f8d99a")
	bar_background.set_border_width_all(2)
	var bar_fill := StyleBoxFlat.new()
	bar_fill.bg_color = Color("#ffd36e")
	charge_bar.add_theme_stylebox_override("background", bar_background)
	charge_bar.add_theme_stylebox_override("fill", bar_fill)
	root.add_child(charge_bar)


func _create_label(parent: Node, text_value: String, position_value: Vector2, size_value: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.position = position_value
	label.size = size_value
	label.add_theme_font_override("font", PIXEL_FONT)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parent.add_child(label)
	return label


func set_jump_count(count: int) -> void:
	if jump_label != null:
		jump_label.text = "PULOS %d" % count


func set_phase_progress(amount: float) -> void:
	if height_progress_bar != null:
		height_progress_bar.value = clampf(amount, 0.0, 1.0) * 100.0


func set_time(seconds: float) -> void:
	if time_label == null:
		return
	var total_seconds: int = maxi(0, int(seconds))
	var minutes: int = total_seconds / 60
	var remainder: int = total_seconds % 60
	time_label.text = "%02d:%02d" % [minutes, remainder]


func set_charge(amount: float) -> void:
	if charge_bar == null:
		return
	var percentage: float = clampf(amount, 0.0, 1.0) * 100.0
	charge_bar.value = percentage
	charge_bar.visible = percentage > 0.0
