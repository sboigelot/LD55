extends Spatial
class_name Shrine

signal pressed
signal mana_generated(amount)

var used:bool = false

export(NodePath) var np_mesh_spatial
export(NodePath) var np_mesh_outline_spatial

onready var mesh_instance:Spatial = get_node(np_mesh_spatial) as Spatial
onready var outline_mesh_instance:Spatial = get_node(np_mesh_outline_spatial) as Spatial

onready var tutorial_hover_label_3d:HoverLabel3D = $HoverLabel3D

func _ready():
	outline_mesh_instance.visible = false
	Game.level.connect("tutorial_step_changed", self, "on_tutorial_step_changed")

func on_tutorial_step_changed():
	update_tutorial()

func update_tutorial():
	var step = Game.level.tutorial_shrine_gem_click

	match(step):
		0:
			tutorial_hover_label_3d.text = "Click this Shrine!"
			tutorial_hover_label_3d.visible = true
		1:
			tutorial_hover_label_3d.visible = false

func move_to_tuto_step(step):
	Game.level.tutorial_shrine_gem_click = max(Game.level.tutorial_shrine_gem_click, step)
	Game.level.emit_signal("tutorial_step_changed")
	
func _on_Area_mouse_entered():
	if used:
		return
	outline_mesh_instance.visible = true

func _on_Area_mouse_exited():
	outline_mesh_instance.visible = false

func _on_Area_input_event(camera, event, position, normal, shape_idx):
	
	if is_queued_for_deletion():
		return
		
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT):
		if event.pressed:
			emit_signal("pressed")
		
func _on_Shrine_pressed():
	if used:
		return
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.DING)
	used = true
	outline_mesh_instance.visible = false
	
	move_to_tuto_step(1)
	var mana_generated = Game.level.carriage.mana_max - Game.level.carriage.mana
	Game.level.generate_mana(mana_generated)
	Game.level.spawn_floating_label_3d(global_translation, "+%d mana" % mana_generated)
	emit_signal("mana_generated", mana_generated)
