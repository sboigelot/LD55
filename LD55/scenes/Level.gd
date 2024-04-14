extends Spatial
class_name Level

signal tutorial_step_changed

const floating_label_scene = preload("res://Utilities/2D/FloatingLabel.tscn")
export(NodePath) var np_floating_label_placeholder
onready var ui_floating_label_placeholder = get_node(np_floating_label_placeholder) as Node2D

var default_floating_label_offset = Vector2(0, -60)
export var floatng_label_font:Font

export(NodePath) var np_mana_title

export(NodePath) var np_buy_mana_regen_label
export(NodePath) var np_buy_mana_regen_button

export(NodePath) var np_buy_mana_max_label
export(NodePath) var np_buy_mana_max_button

export(NodePath) var np_buy_spell_cost_label
export(NodePath) var np_buy_spell_cost_button

onready var ui_mana_title = get_node(np_mana_title) as Label

onready var ui_buy_mana_regen_label = get_node(np_buy_mana_regen_label) as Label
onready var ui_buy_mana_regen_button = get_node(np_buy_mana_regen_button) as Button

onready var ui_buy_mana_max_label = get_node(np_buy_mana_max_label) as Label
onready var ui_buy_mana_max_button = get_node(np_buy_mana_max_button) as Button

onready var ui_buy_spell_cost_label = get_node(np_buy_spell_cost_label) as Label
onready var ui_buy_spell_cost_button = get_node(np_buy_spell_cost_button) as Button

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

export(NodePath) var np_buy_left_miner_cost_label
export(NodePath) var np_buy_left_miner_button

export(NodePath) var np_buy_left_miner_life_upgrade_cost_label
export(NodePath) var np_buy_left_miner_life_upgrade_button

export(NodePath) var np_buy_left_miner_mining_upgrade_cost_label
export(NodePath) var np_buy_left_miner_mining_upgrade_button

export(NodePath) var np_buy_right_miner_cost_label
export(NodePath) var np_buy_right_miner_button

export(NodePath) var np_buy_right_miner_life_upgrade_cost_label
export(NodePath) var np_buy_right_miner_life_upgrade_button

export(NodePath) var np_buy_right_miner_mining_upgrade_cost_label
export(NodePath) var np_buy_right_miner_mining_upgrade_button

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

onready var ui_buy_left_miner_cost_label = get_node(np_buy_left_miner_cost_label) as Label
onready var ui_buy_left_miner_button = get_node(np_buy_left_miner_button) as Button

onready var ui_buy_left_miner_life_upgrade_cost_label = get_node(np_buy_left_miner_life_upgrade_cost_label) as Label
onready var ui_buy_left_miner_life_upgrade_button = get_node(np_buy_left_miner_life_upgrade_button) as Button

onready var ui_buy_left_miner_mining_upgrade_cost_label = get_node(np_buy_left_miner_mining_upgrade_cost_label) as Label
onready var ui_buy_left_miner_mining_upgrade_button = get_node(np_buy_left_miner_mining_upgrade_button) as Button

onready var ui_buy_right_miner_cost_label = get_node(np_buy_right_miner_cost_label) as Label
onready var ui_buy_right_miner_button = get_node(np_buy_right_miner_button) as Button

onready var ui_buy_right_miner_life_upgrade_cost_label = get_node(np_buy_right_miner_life_upgrade_cost_label) as Label
onready var ui_buy_right_miner_life_upgrade_button = get_node(np_buy_right_miner_life_upgrade_button) as Button

onready var ui_buy_right_miner_mining_upgrade_cost_label = get_node(np_buy_right_miner_mining_upgrade_cost_label) as Label
onready var ui_buy_right_miner_mining_upgrade_button = get_node(np_buy_right_miner_mining_upgrade_button) as Button


const road_lenght:float = 30.0
export(Array, String) var road_layout = [
	"Gem1",
	"Gem1",
	"Base",
	"Base",
	"Gem1",
	"Gem1", 
	"Base", 
	"Base",
	"Gem1",
	"Gem1",
	"Gem1",
	"Base",
	"Base",
	"Gem1",
	"Gem1", 
	"Base", 
	"Base",
	"Gem1",
	"",
]
onready var total_distance:float = ((road_layout.size() - 2) * road_lenght)

var game_speed: float =  1.0
export var time_left: float = 5.0 * 60.0

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
	
	update_time_left(delta)
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
	
func update_time_left(delta):
	if is_paused():
		return
		
	time_left -= delta
	if time_left <= 0.0:
		defeat()

func generate_mana(mana_generated):
	carriage.mana += mana_generated

func victory():
	pass
	
func defeat():
	pass

func update_ui():
	debug_rtb.bbcode_text = ("[b]Time Left:[/b] %2d:%2d\n" + 
		"[b]speed:[/b] %.2f m/s\n" + 
		"[b]distance:[/b] %.2f / %.2f m\n") % [
			int(time_left) / 60,
			int(time_left) % 60,
			carriage.speed,
			carriage.distance_travelled,
			total_distance
		]
		
	ui_mana_title.text = "Mana: %d / %d" % [
			carriage.mana,
			carriage.mana_max	
		]

	update_shop_ui()

func update_shop_item(cost_label, button, header, cost, can_add):
	if can_add:
		cost_label.text = "%s%s%d mana" % [header, "" if header == "" else "\n", cost]
		button.disabled = carriage.mana < cost
	else:
		cost_label.text = "%s%sMAX" % [header, "" if header == "" else "\n"]
		button.disabled = true


func update_shop_ui():
	
	update_shop_item(
		ui_buy_mana_regen_label,
		ui_buy_mana_regen_button,
		"%+.2f /sec" % [carriage.mana_regen],
		carriage.get_mana_regen_upgrade_cost(),
		true
	)
	
	update_shop_item(
		ui_buy_mana_max_label,
		ui_buy_mana_max_button,
		"%d" % [carriage.mana_max],
		carriage.get_mana_max_upgrade_cost(),
		true
	)

	update_shop_item(
		ui_buy_spell_cost_label,
		ui_buy_spell_cost_button,
		"%.2f" % [carriage.spell_cost],
		carriage.get_spell_cost_upgrade_cost(),
		true
	)

	update_shop_item(
		ui_buy_front_carrier_cost_label,
		ui_buy_front_carrier_button,
		"%d" % [carriage.front_carrier_lifes.size()],
		carriage.get_new_front_carrier_cost(),
		carriage.can_add_front_carrier()
	)
	
	update_shop_item(
		ui_buy_front_carrier_life_upgrade_cost_label,
		ui_buy_front_carrier_life_upgrade_button,
		"%.2f sec" % [carriage.get_front_carrier_lifespan()],
		carriage.get_front_carrier_life_upgrade_cost(),
		true
	)
	
	update_shop_item(
		ui_buy_front_carrier_speed_upgrade_cost_label,
		ui_buy_front_carrier_speed_upgrade_button,
		"%.2f m/sec" % [carriage.get_front_carrier_speed()],
		carriage.get_front_carrier_speed_upgrade_cost(),
		true
	)
	
	update_shop_item(
		ui_buy_back_carrier_cost_label,
		ui_buy_back_carrier_button,
		"%d" % [carriage.back_carrier_lifes.size()],
		carriage.get_new_back_carrier_cost(),
		carriage.can_add_back_carrier()
	)
	
	update_shop_item(
		ui_buy_back_carrier_life_upgrade_cost_label,
		ui_buy_back_carrier_life_upgrade_button,
		"%.2f sec" % [carriage.get_back_carrier_lifespan()],
		carriage.get_back_carrier_life_upgrade_cost(),
		true
	)
	
	update_shop_item(
		ui_buy_back_carrier_speed_upgrade_cost_label,
		ui_buy_back_carrier_speed_upgrade_button,
		"%.2f m/sec" % [carriage.get_back_carrier_speed()],
		carriage.get_back_carrier_speed_upgrade_cost(),
		true
	)
	
	update_shop_item(
		ui_buy_left_miner_cost_label,
		ui_buy_left_miner_button,
		"%d" % [carriage.left_miner_lifes.size()],
		carriage.get_new_left_miner_cost(),
		carriage.can_add_left_miner()
	)
	
	update_shop_item(
		ui_buy_left_miner_life_upgrade_cost_label,
		ui_buy_left_miner_life_upgrade_button,
		"%.2f sec" % [carriage.get_left_miner_lifespan()],
		carriage.get_left_miner_life_upgrade_cost(),
		true
	)
	
#	update_shop_item(
#		ui_buy_left_miner_mining_upgrade_cost_label,
#		ui_buy_left_miner_mining_upgrade_button,
#		"",
#		2,
#		false
#	)

	update_shop_item(
		ui_buy_right_miner_cost_label,
		ui_buy_right_miner_button,
		"%d" % [carriage.right_miner_lifes.size()],
		carriage.get_new_right_miner_cost(),
		carriage.can_add_right_miner()
	)
		
	update_shop_item(
		ui_buy_right_miner_life_upgrade_cost_label,
		ui_buy_right_miner_life_upgrade_button,
		"%.2f sec" % [carriage.get_right_miner_lifespan()],
		carriage.get_right_miner_life_upgrade_cost(),
		true
	)
	
#	update_shop_item(
#		ui_buy_right_miner_mining_upgrade_cost_label,
#		ui_buy_right_miner_mining_upgrade_button,
#		"",
#		4,
#		false
#	)

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
	var cost = carriage.get_front_carrier_life_upgrade_cost()
	carriage.upgrade_front_carrier_life()
	carriage.mana -= cost
	
func _on_BuyFCSUButton_pressed():
	var cost = carriage.get_front_carrier_speed_upgrade_cost()
	carriage.upgrade_front_carrier_speed()
	carriage.mana -= cost

func _on_BuyBCButton_pressed():
	var cost = carriage.get_new_back_carrier_cost()
	if carriage.add_back_carrier():
		carriage.mana -= cost

func _on_BuyBCLUButton_pressed():
	var cost = carriage.get_back_carrier_life_upgrade_cost()
	carriage.upgrade_back_carrier_life()
	carriage.mana -= cost

func _on_BuyBCSUButton_pressed():
	var cost = carriage.get_back_carrier_speed_upgrade_cost()
	carriage.upgrade_back_carrier_speed()
	carriage.mana -= cost

func _on_BuyLMButton_pressed():
	var cost = carriage.get_new_left_miner_cost()
	if carriage.add_left_miner():
		carriage.mana -= cost


func _on_BuyLMLUButton_pressed():
	var cost = carriage.get_left_miner_life_upgrade_cost()
	carriage.upgrade_left_miner_life()
	carriage.mana -= cost


func _on_BuyLMMUButton_pressed():
	pass # Replace with function body.


func _on_BuyRMButton_pressed():
	var cost = carriage.get_new_right_miner_cost()
	if carriage.add_right_miner():
		carriage.mana -= cost


func _on_BuyRMLUButton_pressed():
	var cost = carriage.get_right_miner_life_upgrade_cost()
	carriage.upgrade_right_miner_life()
	carriage.mana -= cost

func _on_BuyRMMUButton_pressed():
	pass # Replace with function body.

func _on_BuyRegenButton_pressed():
	var cost = carriage.get_mana_regen_upgrade_cost()
	carriage.upgrade_mana_regen()
	carriage.mana -= cost

func _on_BuyMaxManaButton_pressed():
	var cost = carriage.get_mana_max_upgrade_cost()
	carriage.upgrade_mana_max()
	carriage.mana -= cost

func _on_BuySpellCostButton_pressed():
	var cost = carriage.get_spell_cost_upgrade_cost()
	carriage.upgrade_spell_cost()
	carriage.mana -= cost
