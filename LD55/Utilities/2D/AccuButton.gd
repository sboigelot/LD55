tool
extends MarginContainer

class_name AccumulatorButton

signal accumulated
signal clicked

export(NodePath) var np_button
export(NodePath) var np_progress_bar
export(NodePath) var np_label
export(NodePath) var np_texture_rect

onready var button = get_node(np_button) as Button
onready var progress_bar = get_node(np_progress_bar) as Range
onready var label = get_node(np_label) as Label
onready var texture_rect = get_node_or_null(np_texture_rect) as TextureRect

export var text:String = "" setget set_text
export var button_color:Color = Color.white setget set_button_color
export var center_label: bool = false setget set_center_label
export var font: Font setget set_font
export var font_color: Color = Color(0.439216, 0.34902, 0.133333) setget set_font_color
export var disabled: bool = false setget set_disabled
export var accept_player_click: bool = true
export var icon:Texture setget set_icon
export var icon_size: Vector2 = Vector2(64, 64) setget set_icon_size
export var disabled_opacity : float = 0.6

export var accumulated_value: float = 0.0
export var click_value: float = 1.0
export var target_value: float = 3.0
export var decay_amount: float = 0.1
export var click_protect_duration: float = 0.1
export var decay_protect_duration: float = 0.1
	
var time_since_last_decay: float
var time_since_last_click: float

			
func set_button_color(value):
	button_color = value
	var button = get_node_or_null(np_button) as Button
	if button != null:
		button.modulate = value
	
func set_text(value):
	text = value
	set_text_and_font()
			
func set_font(value):
	font = value
	set_text_and_font()
	
func set_font_color(value):
	font_color = value
	set_text_and_font()
	
func set_center_label(value):
	center_label = value
	set_text_and_font()
	
func set_text_and_font():
	var label = get_node_or_null(np_label) as Label
	if label != null:
		label.text = text
		label.add_color_override("font_color", font_color)
		if center_label:
			label.rect_position = Vector2(
				-label.rect_size.x / 2 + 32,
				label.rect_position.y
			)
			
		if font != null:
			label.add_font_override("font", font) 
		else:
			label.remove_font_override("font")

func set_disabled(value):
	disabled = value
	
	var button = get_node_or_null(np_button) as Button
	if button != null:
		button.disabled = disabled
		
	var label = get_node_or_null(np_label) as Label
	if label != null:
		label.modulate = Color.red if disabled else Color.white

	var progress_bar = get_node_or_null(np_progress_bar) as TextureProgress
	if progress_bar != null:
		progress_bar.modulate.a = disabled_opacity if disabled else 1.0

	var texture_rect = get_node_or_null(np_texture_rect) as TextureRect
	if texture_rect != null:
		texture_rect.modulate.a = progress_bar.modulate.a
		
func set_icon(value):
	icon = value
	set_icon_and_icon_size()
	
func set_icon_size(value):
	icon_size = value
	set_icon_and_icon_size()
	
func set_icon_and_icon_size():
	var texture_rect = get_node_or_null(np_texture_rect) as TextureRect
	if texture_rect != null:
		texture_rect.texture = icon		
		texture_rect.rect_min_size = icon_size
		texture_rect.rect_size = icon_size
	
func _ready():
	update_ui()
	
func update_ui():
	button.hint_tooltip = hint_tooltip
	progress_bar.modulate.a = disabled_opacity if disabled else 1.0
	progress_bar.max_value = target_value
	progress_bar.value = accumulated_value
		
func _on_Button_pressed():
	if accept_player_click:
		on_click()

func on_click():
	time_since_last_click = 0
	accumulated_value = min(accumulated_value + click_value, target_value)
	update_ui()
	emit_signal("clicked")
	
	if accumulated_value < target_value:
		return
	
	accumulated_value = 0
	time_since_last_decay = 0
	emit_signal("accumulated")

func _process(delta):
	
	if visible and not Engine.is_editor_hint():
		deaccumulate(delta)
	
func deaccumulate(delta):
	time_since_last_click += delta
	if time_since_last_click <= click_protect_duration:
		return
	
	if accumulated_value <= 0:
		return
	
	time_since_last_decay += delta
	if time_since_last_decay <= decay_protect_duration:
		return
		
	time_since_last_decay = 0
	accumulated_value = max(0, accumulated_value - decay_amount)
	
	update_ui()
