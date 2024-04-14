extends Area

signal pressed
signal mana_generated(amount)

export var mana_per_click:int = 1
export var mana_stored:int = 50
var mana_mined:int = 0

onready var mesh_instance:MeshInstance = $MeshInstance
onready var outline_mesh_instance:MeshInstance = $MeshInstance/MeshInstance
onready var tutorial_hover_label_3d:HoverLabel3D = $HoverLabel3D

func _ready():
	outline_mesh_instance.visible = false
	Game.level.connect("tutorial_step_changed", self, "on_tutorial_step_changed")

func on_tutorial_step_changed():
	update_tutorial()

func update_tutorial():
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
	
func _on_Gem_mouse_entered():
	outline_mesh_instance.visible = true

func _on_Gem_mouse_exited():
	outline_mesh_instance.visible = false

func _on_Gem_input_event(camera, event, position, normal, shape_idx):
	
	if is_queued_for_deletion():
		return
		
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT):
		if event.pressed:
			emit_signal("pressed")
		
func _on_Gem_pressed():
	move_to_tuto_step(1)
	var mana_generated = min(mana_per_click, mana_stored - mana_mined)
	mana_mined += mana_generated
	Game.level.generate_mana(mana_generated)
	Game.level.spawn_floating_label_3d(global_translation, "+%d mana" % mana_generated)
	emit_signal("mana_generated", mana_generated)
	scale = Vector3.ONE * float(mana_stored - mana_mined) / mana_stored
	if mana_stored - mana_mined <= 0:
		queue_free()
		move_to_tuto_step(2)
