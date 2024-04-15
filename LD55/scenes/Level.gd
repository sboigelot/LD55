extends Spatial
class_name Level

signal tutorial_step_changed

const floating_label_scene = preload("res://Utilities/2D/FloatingLabel.tscn")
export(NodePath) var np_floating_label_placeholder
onready var ui_floating_label_placeholder = get_node(np_floating_label_placeholder) as Node2D

var default_floating_label_offset = Vector2(0, -60)
export var floatng_label_font:Font

export(NodePath) var np_mana_title
onready var ui_mana_title = get_node(np_mana_title) as Label

export(NodePath) var np_shop_item_mana_regen
export(NodePath) var np_shop_item_mana_max
export(NodePath) var np_shop_item_spell_cost

onready var ui_shop_item_mana_regen = get_node(np_shop_item_mana_regen) as ShopItem
onready var ui_shop_item_mana_max = get_node(np_shop_item_mana_max) as ShopItem
onready var ui_shop_item_spell_cost = get_node(np_shop_item_spell_cost) as ShopItem

export(NodePath) var np_shop_item_back_carrier
export(NodePath) var np_shop_item_back_carrier_lifespan
export(NodePath) var np_shop_item_back_carrier_speed

onready var ui_shop_item_back_carrier = get_node(np_shop_item_back_carrier) as ShopItem
onready var ui_shop_item_back_carrier_lifespan = get_node(np_shop_item_back_carrier_lifespan) as ShopItem
onready var ui_shop_item_back_carrier_speed = get_node(np_shop_item_back_carrier_speed) as ShopItem

export(NodePath) var np_shop_item_front_carrier
export(NodePath) var np_shop_item_front_carrier_lifespan
export(NodePath) var np_shop_item_front_carrier_speed

onready var ui_shop_item_front_carrier = get_node(np_shop_item_front_carrier) as ShopItem
onready var ui_shop_item_front_carrier_lifespan = get_node(np_shop_item_front_carrier_lifespan) as ShopItem
onready var ui_shop_item_front_carrier_speed = get_node(np_shop_item_front_carrier_speed) as ShopItem

export(NodePath) var np_shop_item_left_apprentice
export(NodePath) var np_shop_item_left_apprentice_lifespan

onready var ui_shop_item_left_apprentice = get_node(np_shop_item_left_apprentice) as ShopItem
onready var ui_shop_item_left_apprentice_lifespan = get_node(np_shop_item_left_apprentice_lifespan) as ShopItem

export(NodePath) var np_shop_item_right_apprentice
export(NodePath) var np_shop_item_right_apprentice_lifespan

onready var ui_shop_item_right_apprentice = get_node(np_shop_item_right_apprentice) as ShopItem
onready var ui_shop_item_right_apprentice_lifespan = get_node(np_shop_item_right_apprentice_lifespan) as ShopItem

const road_lenght:float = 30.0
export(Array, String) var road_layout = [
	"Gem1",
	"End",
	"Shrine1",
	"Gem2",
	"Base",
	"Base",
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
	"End",
	"",
]
onready var total_distance:float = ((road_layout.size() - 2) * road_lenght)

var game_speed: float =  1.0
export var time_left: float = 5.0 * 60.0

onready var debug_rtb = $LeftPanelMargin/LeftPanel/VBoxContainer/DebugRichTextLabel
onready var carriage:Carriage = $Carriage

var tutorial_step_gem_click = 0
var tutorial_shrine_gem_click = 0

var front_carrier_upgrade_locked:bool = true
var back_carrier_upgrade_locked:bool = true
var left_apprentice_upgrade_locked:bool = true
var right_apprentice_upgrade_locked:bool = true

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
	debug_rtb.bbcode_text = ("[center][b]Time Left:[/b] %02d:%02d\n" + 
		"[b]Speed:[/b] %.2f m/s\n" + 
		"[b]Distance:[/b] %.2f / %.2f m[/center]") % [
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

func update_shop_item(shop_item:ShopItem, info, mana_cost, can_buy, visible = true):
	shop_item.disabled = not can_buy
	shop_item.mana_cost = mana_cost
	shop_item.info = info
	shop_item.visible = visible

func update_shop_ui():
	
	update_shop_item(
		ui_shop_item_mana_regen,
		"%+.2f /sec" % [carriage.mana_regen],
		carriage.get_mana_regen_upgrade_cost(),
		true
	)
	
	update_shop_item(
		ui_shop_item_mana_max,
		"%d" % [carriage.mana_max],
		carriage.get_mana_max_upgrade_cost(),
		true
	)

	update_shop_item(
		ui_shop_item_spell_cost,
		"%.2f" % [carriage.spell_cost],
		carriage.get_spell_cost_upgrade_cost(),
		true
	)
	
	update_shop_item(
		ui_shop_item_back_carrier,
		"%d" % [carriage.back_carrier_lifes.size()],
		carriage.get_new_back_carrier_cost(),
		carriage.can_add_back_carrier()
	)
	
	update_shop_item(
		ui_shop_item_back_carrier_lifespan,
		"%.2f sec" % [carriage.get_back_carrier_lifespan()],
		carriage.get_back_carrier_life_upgrade_cost(),
		true,
		not back_carrier_upgrade_locked
	)
	
	update_shop_item(
		ui_shop_item_back_carrier_speed,
		"%.2f m/sec" % [carriage.get_back_carrier_speed()],
		carriage.get_back_carrier_speed_upgrade_cost(),
		true,
		not back_carrier_upgrade_locked
	)

	update_shop_item(
		ui_shop_item_front_carrier,
		"%d" % [carriage.front_carrier_lifes.size()],
		carriage.get_new_front_carrier_cost(),
		carriage.can_add_front_carrier()
	)
	
	update_shop_item(
		ui_shop_item_front_carrier_lifespan,
		"%.2f sec" % [carriage.get_front_carrier_lifespan()],
		carriage.get_front_carrier_life_upgrade_cost(),
		true,
		not front_carrier_upgrade_locked
	)
	
	update_shop_item(
		ui_shop_item_front_carrier_speed,
		"%.2f m/sec" % [carriage.get_front_carrier_speed()],
		carriage.get_front_carrier_speed_upgrade_cost(),
		true,
		not front_carrier_upgrade_locked
	)
	
	update_shop_item(
		ui_shop_item_left_apprentice,
		"%d" % [carriage.left_miner_lifes.size()],
		carriage.get_new_left_miner_cost(),
		carriage.can_add_left_miner()
	)
	
	update_shop_item(
		ui_shop_item_left_apprentice_lifespan,
		"%.2f sec" % [carriage.get_left_miner_lifespan()],
		carriage.get_left_miner_life_upgrade_cost(),
		true,
		not left_apprentice_upgrade_locked
	)

	update_shop_item(
		ui_shop_item_right_apprentice,
		"%d" % [carriage.right_miner_lifes.size()],
		carriage.get_new_right_miner_cost(),
		carriage.can_add_right_miner()
	)
		
	update_shop_item(
		ui_shop_item_right_apprentice_lifespan,
		"%.2f sec" % [carriage.get_right_miner_lifespan()],
		carriage.get_right_miner_life_upgrade_cost(),
		true,
		not right_apprentice_upgrade_locked
	)
	
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
	instance.modulate = Color.black
#	instance.icon_path = icon_path #TODO
	instance.text = text
	instance.font = floatng_label_font
	ui_floating_label_placeholder.add_child(instance)
	instance.rect_position = position2d - Vector2(0, -10)

func _on_ManaRegenShopItem_pressed():
	var cost = carriage.get_mana_regen_upgrade_cost()
	carriage.upgrade_mana_regen()
	carriage.mana -= cost


func _on_ManaMaxShopItem2_pressed():
	var cost = carriage.get_mana_max_upgrade_cost()
	carriage.upgrade_mana_max()
	carriage.mana -= cost


func _on_SpellCostShopItem3_pressed():
	var cost = carriage.get_spell_cost_upgrade_cost()
	carriage.upgrade_spell_cost()
	carriage.mana -= cost

func _on_ShopItemNewBC_pressed():
	var cost = carriage.get_new_back_carrier_cost()
	if carriage.add_back_carrier():
		carriage.mana -= cost
		back_carrier_upgrade_locked = false

func _on_ShopItemUpBCL_pressed():
	var cost = carriage.get_back_carrier_life_upgrade_cost()
	carriage.upgrade_back_carrier_life()
	carriage.mana -= cost

func _on_ShopItemUpBCS_pressed():
	var cost = carriage.get_back_carrier_speed_upgrade_cost()
	carriage.upgrade_back_carrier_speed()
	carriage.mana -= cost

func _on_ShopItemNewFC_pressed():
	var cost = carriage.get_new_front_carrier_cost()
	if carriage.add_front_carrier():
		carriage.mana -= cost
		front_carrier_upgrade_locked = false

func _on_ShopItemUpFCL_pressed():
	var cost = carriage.get_front_carrier_life_upgrade_cost()
	carriage.upgrade_front_carrier_life()
	carriage.mana -= cost

func _on_ShopItemUpFCS_pressed():
	var cost = carriage.get_front_carrier_speed_upgrade_cost()
	carriage.upgrade_front_carrier_speed()
	carriage.mana -= cost

func _on_ShopItemNewLA_pressed():
	var cost = carriage.get_new_left_miner_cost()
	if carriage.add_left_miner():
		carriage.mana -= cost
		left_apprentice_upgrade_locked = false

func _on_ShopItemUpLAL_pressed():
	var cost = carriage.get_left_miner_life_upgrade_cost()
	carriage.upgrade_left_miner_life()
	carriage.mana -= cost

func _on_ShopItemNewRA_pressed():
	var cost = carriage.get_new_right_miner_cost()
	if carriage.add_right_miner():
		carriage.mana -= cost
		right_apprentice_upgrade_locked = false

func _on_ShopItemUpRAL_pressed():
	var cost = carriage.get_right_miner_life_upgrade_cost()
	carriage.upgrade_right_miner_life()
	carriage.mana -= cost
