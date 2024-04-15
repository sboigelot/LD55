extends Spatial

class_name Gem

signal pressed
signal mana_generated(amount)

export var allow_player_click:bool = false
export var mana_per_click:int = 1
export var mana_stored:int = 50
var mana_mined:int = 0

export(NodePath) var np_mesh_spatial
export(NodePath) var np_mesh_outline_spatial

onready var mesh_instance:Spatial = get_node(np_mesh_spatial) as Spatial
onready var outline_mesh_instance:Spatial = get_node(np_mesh_outline_spatial) as Spatial

onready var tutorial_hover_label_3d:HoverLabel3D = $HoverLabel3D

var passed_carriage: bool = false

func _ready():
	outline_mesh_instance.visible = false
	Game.level.connect("tutorial_step_changed", self, "on_tutorial_step_changed")
	update_tutorial()

func _process(delta):
	if not passed_carriage and global_translation.x <= 2.0:
		passed_carriage = true
		Game.level.carriage.on_gem_reach_carriage(self)

func on_tutorial_step_changed():
	update_tutorial()

func update_tutorial():
	if not allow_player_click:
		tutorial_hover_label_3d.visible = false
		return
		
	var step = Game.level.tutorial_step_gem_click

	match(step):
		0:
			tutorial_hover_label_3d.text = "Click this gemstone!"
			tutorial_hover_label_3d.visible = true
		1:
			tutorial_hover_label_3d.text = "Click it again!"
			tutorial_hover_label_3d.visible = true
		2:
			tutorial_hover_label_3d.visible = false

func move_to_tuto_step(step):
	Game.level.tutorial_step_gem_click = max(Game.level.tutorial_step_gem_click, step)
	Game.level.emit_signal("tutorial_step_changed")
	
func _on_Area_mouse_entered():
	if not allow_player_click:
		return
	outline_mesh_instance.visible = true

func _on_Area_mouse_exited():
	outline_mesh_instance.visible = false

func _on_Area_input_event(camera, event, position, normal, shape_idx):
	
	if not allow_player_click:
		return
		
	if is_queued_for_deletion():
		return
		
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT):
		if event.pressed:
			emit_signal("pressed")
		
func _on_Gem_pressed():
	if Game.level.tutorial_step_gem_click > 0:
		move_to_tuto_step(2)
	else:
		move_to_tuto_step(1)
	var mana_generated = min(mana_per_click, mana_stored - mana_mined)
	mana_mined += mana_generated
	Game.level.generate_mana(mana_generated)
	Game.level.spawn_floating_label_3d(global_translation, "+%d mana" % mana_generated)
	emit_signal("mana_generated", mana_generated)
	scale = Vector3.ONE * float(mana_stored - mana_mined) / mana_stored
	if mana_stored - mana_mined <= 0:
		queue_free()

