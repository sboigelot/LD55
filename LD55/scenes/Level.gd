extends Spatial
class_name Level

signal tutorial_step_changed

const floating_label_scene = preload("res://Utilities/2D/FloatingLabel.tscn")
export(NodePath) var np_floating_label_placeholder
onready var ui_floating_label_placeholder = get_node(np_floating_label_placeholder) as Node2D

var default_floating_label_offset = Vector2(0, -60)
export var floatng_label_font:Font

export(NodePath) var np_buy_front_carrier_cost_label
export(NodePath) var np_buy_front_carrier_button

export(NodePath) var np_buy_front_carrier_life_upgrade_cost_label
export(NodePath) var np_buy_front_carrier_life_upgrade_button

export(NodePath) var np_buy_front_carrier_speed_upgrade_cost_label
export(NodePath) var np_buy_front_carrier_speed_upgrade_button

export(NodePath) var np_buy_back_carrier_cost_label
export(NodePath) var np_buy_back_carrier_button

export(NodePath) var np_buy_back_carrier_life_upgrade_cost_label
export(NodePath) var np_buy_back_carrier_life_upgrade_button

export(NodePath) var np_buy_back_carrier_speed_upgrade_cost_label
export(NodePath) var np_buy_back_carrier_speed_upgrade_button

onready var ui_buy_front_carrier_cost_label = get_node(np_buy_front_carrier_cost_label) as Label
onready var ui_buy_front_carrier_button = get_node(np_buy_front_carrier_button) as Button

onready var ui_buy_front_carrier_life_upgrade_cost_label = get_node(np_buy_front_carrier_life_upgrade_cost_label) as Label
onready var ui_buy_front_carrier_life_upgrade_button = get_node(np_buy_front_carrier_life_upgrade_button) as Button

onready var ui_buy_front_carrier_speed_upgrade_cost_label = get_node(np_buy_front_carrier_speed_upgrade_cost_label) as Label
onready var ui_buy_front_carrier_speed_upgrade_button = get_node(np_buy_front_carrier_speed_upgrade_button) as Button

onready var ui_buy_back_carrier_cost_label = get_node(np_buy_back_carrier_cost_label) as Label
onready var ui_buy_back_carrier_button = get_node(np_buy_back_carrier_button) as Button

onready var ui_buy_back_carrier_life_upgrade_cost_label = get_node(np_buy_back_carrier_life_upgrade_cost_label) as Label
onready var ui_buy_back_carrier_life_upgrade_button = get_node(np_buy_back_carrier_life_upgrade_button) as Button

onready var ui_buy_back_carrier_speed_upgrade_cost_label= get_node(np_buy_back_carrier_speed_upgrade_cost_label) as Label
onready var ui_buy_back_carrier_speed_upgrade_button = get_node(np_buy_back_carrier_speed_upgrade_button) as Button

const road_lenght:float = 30.0
export(Array, String) var road_layout = [
	"Base",
	"Gem1", 
	"Gem1",
	"Base"
]

var game_speed: float =  1.0

onready var debug_rtb = $MarginContainer/PanelContainer/VBoxContainer/DebugRichTextLabel
onready var carriage:Carriage = $Carriage

var tutorial_step_gem_click = 0

func is_paused()->bool:
	return game_speed == 0

func _ready():
	if Game.level != null and is_instance_valid(Game.level):
		Game.level.queue_free()
	Game.level = self
	load_initial_roads()
	update_ui()

func load_initial_roads():
	var roads = $Roads.get_children()
	roads.pop_front()
	for road in roads:
		load_next_road(road)

func load_next_road(road:Spatial) -> bool:
	if road_layout.size() == 0:
		return false
	var next_road_type = road_layout.pop_front()
	Game.instanciate_road(road, true, next_road_type)
	return true

func _process(delta):
	update_ui()
	if is_paused():
		return
		
	move_roads(delta)

func move_roads(delta):
	var travel = carriage.speed * game_speed * delta
	carriage.distance_travelled += travel
	var roads = $Roads.get_children()
	for road in roads:
		road.translation.x -= travel
		if road.translation.x < -road_lenght:
			road.translation.x += roads.size() * road_lenght
			if not load_next_road(road):
				game_speed = 0.0
				victory()

func generate_mana(mana_generated):
	carriage.mana += mana_generated

func victory():
	pass

func update_ui():
	debug_rtb.bbcode_text = ("[b]mana:[/b] %d\n" + 
		"[b]speed:[/b] %.2f m/s\n" + 
		"[b]distance:[/b] %.2f m\n") % [
			carriage.mana,
			carriage.speed,
			carriage.distance_travelled
		]
		
	update_shop_ui()

func update_shop_ui():
	ui_buy_front_carrier_cost_label.text = "%d mana" % carriage.get_new_front_carrier_cost()
	ui_buy_front_carrier_button.disabled = carriage.mana < carriage.get_new_front_carrier_cost()
	
	ui_buy_front_carrier_life_upgrade_cost_label.text = "%d mana" % carriage.get_front_carrier_life_upgrade_cost()
	ui_buy_front_carrier_life_upgrade_button.disabled = carriage.mana < carriage.get_front_carrier_life_upgrade_cost()
	
	ui_buy_front_carrier_speed_upgrade_cost_label.text = "%d mana" % carriage.get_front_carrier_speed_upgrade_cost()
	ui_buy_front_carrier_speed_upgrade_button.disabled = carriage.mana < carriage.get_front_carrier_speed_upgrade_cost()
	
	ui_buy_back_carrier_cost_label.text = "%d mana" % carriage.get_new_back_carrier_cost()
	ui_buy_back_carrier_button.disabled = carriage.mana < carriage.get_new_back_carrier_cost()
	
	ui_buy_back_carrier_life_upgrade_cost_label.text = "%d mana" % carriage.get_back_carrier_life_upgrade_cost()
	ui_buy_back_carrier_life_upgrade_button.disabled = carriage.mana < carriage.get_back_carrier_life_upgrade_cost()
	
	ui_buy_back_carrier_speed_upgrade_cost_label.text = "%d mana" % carriage.get_back_carrier_speed_upgrade_cost()
	ui_buy_back_carrier_speed_upgrade_button.disabled = carriage.mana < carriage.get_back_carrier_speed_upgrade_cost()


func postion3d_to_screen(position3d:Vector3, offset:Vector2 = Vector2.ZERO) -> Vector2:
	var current_camera = $Camera
	var position2d = current_camera.unproject_position(position3d)
	return position2d + offset
	
func spawn_floating_label_3d(position3d:Vector3, text:String, icon_path:String = ""):
	var position2d = postion3d_to_screen(position3d, default_floating_label_offset)
	spawn_floating_label(position2d, text, icon_path)
	
func spawn_floating_label(position2d:Vector2, text:String, icon_path:String = ""):
	var instance = floating_label_scene.instance()
#	instance.lifetime = 0.6
#	instance.font = Game.floatng_label_font
#	instance.direction = Vector2(+.5, -0.5)
#	instance.modulate = color
#	instance.icon_path = icon_path #TODO
	instance.text = text
	instance.font = floatng_label_font
	ui_floating_label_placeholder.add_child(instance)
	instance.rect_position = position2d

func _on_BuyFCButton_pressed():
	var cost = carriage.get_new_front_carrier_cost()
	if carriage.add_front_carrier():
		carriage.mana -= cost


func _on_BuyFCLUButton_pressed():
	pass # Replace with function body.


func _on_BuyFCSUButton_pressed():
	pass # Replace with function body.


func _on_BuyBCButton_pressed():
	var cost = carriage.get_new_back_carrier_cost()
	if carriage.add_back_carrier():
		carriage.mana -= cost


func _on_BuyBCLUButton_pressed():
	pass # Replace with function body.


func _on_BuyBCSUButton_pressed():
	pass # Replace with function body.
