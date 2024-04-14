tool
extends Spatial

class_name HoverLabel3D

export var text: String = "Click Me!" setget set_text
export var font:Font setget set_font

export(NodePath) var np_animation_player
onready var sp_anomation_player = get_node(np_animation_player) as AnimationPlayer

func set_text(value):
	text = value
	var lable = get_node_or_null("Label") 
	if lable != null:
		lable.text = text
		lable.font = font
		
func set_font(value):
	font = value
	var lable = get_node_or_null("Label") 
	if lable != null:
		lable.font = font

func _process(delta):
	if Engine.is_editor_hint():
		get_node(np_animation_player).stop(false)
		return

func _ready():
	if visible:
		if not sp_anomation_player.is_playing():
			sp_anomation_player.play("Hover")

func popup():
	if visible:
		return
		
	visible = true
	sp_anomation_player.play("Hover")
	
func hide():
	if not visible:
		return
		
	visible = false
	sp_anomation_player.stop(true)
