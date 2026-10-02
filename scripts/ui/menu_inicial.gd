extends Control

const PIXEL_FONT: FontFile = preload("res://assets/ui/fonts/pixelify_sans.ttf")
const MIMI_SPRITES = preload("res://scripts/gameplay/mimi_sprites.gd")


func _ready() -> void:
	var viewport_size := get_viewport_rect().size
	var center_x := viewport_size.x / 2.0
	var background := FundoPixel.new()
	add_child(background)
	background.setup(viewport_size)
	var hero: AnimatedSprite2D = MIMI_SPRITES.create_sprite(&"jump")
	hero.position = Vector2(center_x, viewport_size.y * 0.43)
	hero.scale = Vector2(4.0, 4.0)
	add_child(hero)

	_add_label("MIAU NO GALHO", Vector2(center_x - 360.0, viewport_size.y * 0.16), Vector2(720.0, 80.0), 58, Color("#ffe0a3"))

	var play_y := viewport_size.y * 0.55
	var play_button := _add_button("JOGAR", Vector2(center_x - 150.0, play_y), Vector2(300.0, 60.0))
	play_button.pressed.connect(_on_play_pressed)
	var quit_button := _add_button("SAIR", Vector2(center_x - 150.0, play_y + 76.0), Vector2(300.0, 60.0))
	quit_button.pressed.connect(_on_quit_pressed)

	_add_label("A / D: direção   •   Espaço: segure e solte", Vector2(center_x - 300.0, viewport_size.y - 58.0), Vector2(600.0, 28.0), 20, Color("#fff1d2"))
	play_button.grab_focus()
	AudioMiau.play_music()


func _add_label(text_value: String, position_value: Vector2, size_value: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.position = position_value
	label.size = size_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", PIXEL_FONT)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color("#24304b"))
	label.add_theme_constant_override("outline_size", 4)
	add_child(label)
	return label


func _add_button(text_value: String, position_value: Vector2, size_value: Vector2) -> Button:
	var button := Button.new()
	button.text = text_value
	button.position = position_value
	button.size = size_value
	button.add_theme_font_override("font", PIXEL_FONT)
	button.add_theme_font_size_override("font_size", 28)
	button.add_theme_color_override("font_color", Color("#fff8e7"))
	button.add_theme_color_override("font_hover_color", Color("#ffffff"))
	button.add_theme_color_override("font_pressed_color", Color("#fff1d2"))
	button.add_theme_color_override("font_focus_color", Color("#ffffff"))
	button.add_theme_color_override("font_outline_color", Color("#171322"))
	button.add_theme_constant_override("outline_size", 3)
	button.add_theme_stylebox_override("normal", _make_button_style(Color("#241d36"), Color("#f8d99a"), 2))
	button.add_theme_stylebox_override("hover", _make_button_style(Color("#5a3f61"), Color("#ffe7b0"), 3))
	button.add_theme_stylebox_override("pressed", _make_button_style(Color("#8b5a35"), Color("#ffffff"), 3))
	button.add_theme_stylebox_override("focus", _make_button_style(Color("#3a2a4a"), Color("#ffffff"), 3))
	button.add_theme_stylebox_override("disabled", _make_button_style(Color("#241d36"), Color("#8e849c"), 2))
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_child(button)
	return button


func _make_button_style(background: Color, border: Color, border_width: int) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.border_width_left = border_width
	style.border_width_top = border_width
	style.border_width_right = border_width
	style.border_width_bottom = border_width
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_right = 4
	style.corner_radius_bottom_left = 4
	style.content_margin_left = 18.0
	style.content_margin_top = 10.0
	style.content_margin_right = 18.0
	style.content_margin_bottom = 10.0
	return style


func _on_play_pressed() -> void:
	AudioMiau.play_sfx("click")
	get_tree().change_scene_to_file("res://scenes/fase_miau.tscn")


func _on_quit_pressed() -> void:
	AudioMiau.quit_game()
