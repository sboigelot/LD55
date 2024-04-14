tool
extends Spatial

class_name FloatingLabel3D

export var text: String = "I Float!" setget set_text
export var font:Font setget set_font

export var lifetime: float = 0.6
export var velocity: Vector3 = Vector3(0, 5, 0)

export var move_on_ready: bool = true
export var free_after_move: bool = false
export var hide_after_move: bool = true
export var reset_after_move: bool = true

onready var moving:bool = move_on_ready
onready var initial_translation:Vector3 = translation
var current_life:float = 0.0

func set_text(value):
	text = value
	var lable = get_node_or_null("Label")
	if lable != null:
		lable.text = text
		
func set_font(value):
	font = value
	var lable = get_node_or_null("Label")
	if lable != null:
		lable.font = font

func _process(delta):
	if Game.pause:
		return
	
	if moving and not Engine.is_editor_hint():
		move(delta)
		
func move(delta):
	current_life += delta
	if current_life >= lifetime:
		moving = false
		if hide_after_move:
			hide()
		if free_after_move:
			queue_free()
		if reset_after_move:
			translation = initial_translation
		return

	translation += (velocity * delta)
	visible = true

func popup():
	if visible:
		return
	visible = true
	current_life = 0
	initial_translation = translation
	moving = true
	
func hide():
	if not visible:
		return
	visible = false
	moving = false
