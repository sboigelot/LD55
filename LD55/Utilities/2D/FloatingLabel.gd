extends Control

class_name FloatingLabel

export var lifetime: float = 0.6
export var float_speed: float = 150.0
export var direction: Vector2 = Vector2(0, -1)

export var text: String
export var font: Font
export var color: Color = Color.white

func _ready():
	visible = false
	$Label.text = text
	if font != null:
		var label:Label = $Label
		label.add_font_override("font", font)
		label.add_color_override("font_color", color)

func _process(delta):
	if Game.level.is_paused():
		return
	
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
		return

	rect_position += (direction * float_speed * delta)
	$Label.rect_position = Vector2(-$Label.rect_size.x/2, 0)
	visible = true
