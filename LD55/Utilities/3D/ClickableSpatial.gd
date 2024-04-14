extends Spatial

class_name ClickableSpatial

signal click(clickable, position, is_human)

export var disable_on_pause: bool = true
export var scale_on_mouse_over: float = 1.05
export var scale_on_click: float = 1.1
export var auto_click_interval: float = 1.0
var time_since_auto_click:float = 0

export(NodePath) var np_clickable_area
onready var clickable_area = get_node_or_null(np_clickable_area) as Area

var last_click_position3d:Vector3
var mouse_over:bool = false
var allow_long_press:bool = false
var mouse_pressed:bool = false

export(NodePath) var np_override_scalable_root
onready var override_scalable_root:Spatial = get_node_or_null(np_override_scalable_root) as Spatial

func _process(delta):
	if Game.pause:
		return
	
	if allow_long_press:
		if mouse_pressed and auto_click_interval != 0.0:
			time_since_auto_click += delta
			if time_since_auto_click >= auto_click_interval:
				_click_action(true)

func _ready():
	
	if clickable_area == null:
		clickable_area = get_node_or_null("Area")
		if clickable_area == null:
			printerr("ClikableSpatial without area")
			return

	if not clickable_area.is_connected("input_event", self, "_on_Area_input_event"):
		clickable_area.connect("input_event", self, "_on_Area_input_event")

	if not clickable_area.is_connected("mouse_entered", self, "_on_Area_mouse_entered"):
		clickable_area.connect("mouse_entered", self, "_on_Area_mouse_entered")

	if not clickable_area.is_connected("mouse_exited", self, "_on_Area_mouse_exited"):
		clickable_area.connect("mouse_exited", self, "_on_Area_mouse_exited")

func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if is_queued_for_deletion():
		return
	
	if disable_on_pause and Game.pause:
		return
		
	if (event is InputEventMouseButton and
		event.button_index == BUTTON_LEFT):
		if event.pressed:
			last_click_position3d = position
			mouse_pressed = true
			_click_action(true)
		else:
			mouse_pressed = false			
			if override_scalable_root == null:
				scale = Vector3.ONE if not mouse_over else (Vector3.ONE * scale_on_mouse_over)
			else:
				override_scalable_root.scale = Vector3.ONE if not mouse_over else (Vector3.ONE * scale_on_mouse_over)
			

func _click_action(is_human:bool):
	time_since_auto_click = 0
	if override_scalable_root == null:
		scale = Vector3.ONE * scale_on_click
	else:
		override_scalable_root.scale = Vector3.ONE * scale_on_click
	emit_signal("click", self, last_click_position3d, is_human)

func _on_Area_mouse_entered():
	mouse_over = true
	if override_scalable_root == null:
		scale = Vector3.ONE * scale_on_mouse_over
	else:
		override_scalable_root.scale = Vector3.ONE * scale_on_mouse_over

func _on_Area_mouse_exited():
	mouse_over = false
	if override_scalable_root == null:
		scale = Vector3.ONE
	else:
		override_scalable_root.scale = Vector3.ONE
