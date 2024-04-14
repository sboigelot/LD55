tool
extends Spatial

export var texture: Texture = preload("res://Sprites/empty.png") setget set_texture

export(NodePath) var np_animation_player
onready var sp_anomation_player = get_node(np_animation_player) as AnimationPlayer

func set_texture(value):
	texture = value
	var sprite3d = get_node_or_null("Sprite3d")
	if sprite3d != null:
		if sprite3d.texture != texture:
			sprite3d.texture = texture
			var texture_size = texture.get_size()
			var target_size = Vector2.ONE * 64
			sprite3d.scale = Vector3(
				target_size.x / texture_size.x,
				target_size.y / texture_size.y,
				1)

func _process(delta):
	if not Engine.is_editor_hint() and Game.pause:
		sp_anomation_player.stop(false)
		return
	
	if visible and not Engine.is_editor_hint():
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
