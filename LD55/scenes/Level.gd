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

export(NodePath) var np_carriage_slider
export(NodePath) var np_distance_rtl

onready var ui_carriage_slider = get_node(np_carriage_slider) as HSlider
onready var ui_distance_rtl = get_node(np_distance_rtl) as RichTextLabel

const road_lenght:float = 30.0
var road_layout = [
	"Gem1",
	"Gem2",
	"Shrine1",
	"Base",
	"Gem2",
	"Base",
	"Base",
	"Gem1", 
	"Base", 
	"Base",
	"Gem1",
	"Shrine1",
	"Gem1",
	"Base",
	"Base",
	"Gem1",
	"Gem2", 
	"Base", 
	"Base",
	"Gem1",
	"End",
	"",
]
onready var total_distance:float = ((road_layout.size() - 2) * road_lenght)

export(NodePath) var np_progress_map
onready var progress_map = get_node(np_progress_map) as Container
var progress_map_crystal_slider_scene = preload("res://scenes/ProgressMap/CrystalSlider.tscn")
var progress_map_shrine_slider_scene = preload("res://scenes/ProgressMap/ShrineSlider.tscn")

var progress_map_pins_per_roads:Dictionary = {
	"Gem": progress_map_crystal_slider_scene,
	"Shrine": progress_map_shrine_slider_scene
}

var game_speed: float =  1.0
export var time_left: float = 5.0 * 60.0

export(NodePath) var np_debug_rtl
onready var debug_rtl = get_node(np_debug_rtl) as RichTextLabel
onready var carriage:Carriage = $Carriage

export(NodePath) var np_left_panel
onready var ui_left_panel = get_node(np_left_panel) as Container

export(NodePath) var np_message
export(NodePath) var np_message_title
export(NodePath) var np_message_rtl
export(NodePath) var np_message_button
export(NodePath) var np_message_skip_button

onready var ui_message = get_node(np_message) as Container
onready var ui_message_title = get_node(np_message_title) as Label
onready var ui_message_rtl = get_node(np_message_rtl) as RichTextLabel
onready var ui_message_button = get_node(np_message_button) as Button
onready var ui_message_skip_button = get_node(np_message_skip_button) as Button
var ui_message_meta:String

func show_message(title:String, content:String, button_text:String, meta:String):
	game_speed = 0.0
	ui_message_title.text = title
	ui_message_rtl.bbcode_text = content
	ui_message_button.text = button_text
	ui_message_meta = meta
	ui_message.visible = true
	ui_left_panel.modulate = Color(1.0, 1.0, 1.0, 0.5)
	ui_message_skip_button.visible = "intro" in meta
	
func hide_message():
	game_speed = 1.0
	ui_message.visible = false
	ui_left_panel.modulate = Color.white

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
	
	ui_message.visible = false
	
	show_message(
		"A summon from the Emperor", 
		(
			"[center]"+
				"The Emperor appointed you to carry the tax from your village to his castle!\n\n" +
				"Unfortunatly you are a weak wizard!\n\n" +
				"You need to summon magical carriers to help you." +
			"[/center]"
		),
		"Alacazam",
		"intro1")
		
	create_progress_map()
	load_initial_roads()
	update_ui()
	
func _on_MessageSkipButton_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.DING)
	hide_message()
	
func _on_MessageOkButton_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.DING)
	hide_message()
	
	match(ui_message_meta):
		"intro1":
			show_message(
				"A summon from the Emperor", 
				(
					"[center]"+
						"Summoning cost Mana!\n\n" +
						"Gain more mana by summoning Apprentice to collect crystal on your journey\n\n" +
						"That's it, no more tutorial, good luck!" +
					"[/center]"
				),
				"Abracadabra",
				"intro2")
				
		"victory":
			Game.restart()
			
		"defeat":
			Game.restart()
	
func create_progress_map():
	for i in road_layout.size():
		var scene = null
		for road_start in progress_map_pins_per_roads.keys():
			if road_start in road_layout[i]:
				scene = progress_map_pins_per_roads[road_start]
		if scene == null:
			continue
			
		var instance = scene.instance() as HSlider
		instance.max_value = total_distance
		instance.value = i * road_lenght - (road_lenght/2)
		progress_map.add_child(instance)

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
	ui_carriage_slider.max_value = total_distance
	ui_carriage_slider.value = carriage.distance_travelled
	
func _input(event):
	if Input.is_action_just_released("ui_cancel"):
		if not ui_message.visible:
			show_message("Pause","[center]Take a break and breath[/center].", "Resume", "pause")
		else:
			_on_MessageOkButton_pressed()
			
	if Input.is_action_just_released("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
			
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
	show_message(
		"Victory", 
		(
			"[center]"+
			"The Emperor is pleased!\n\n"+
			"You delivered the tax to the Emperor with %d minutes and %d seconds left!\n\n" % [
				int(time_left) / 60,
				int(time_left) % 60
			]+
			"Can you do better?" +
			"[/center]"
		),
		"Retry",
		"victory")
	
func defeat():
	show_message(
		"Defeat", 
		(
			"[center]"+
				"You didn't suceed this time...\n\n" +
				"You ran out of time and the Emperor sent you to work as a toilet scrubber for the rest of your life!\n\n" +
				"Can you do better?" +
			"[/center]"
		),
		"Retry",
		"defeat")

func update_ui():
	debug_rtl.bbcode_text = ("[center][b]Time Left:[/b] %02d:%02d[/center]") % [
			int(time_left) / 60,
			int(time_left) % 60
		]
		
	ui_distance_rtl.bbcode_text = "[center][color=blue]Distance: %.2f / %.2f m\tSpeed: %.2f m/s[/color][/center]" %[
			carriage.distance_travelled,
			total_distance,
			carriage.speed
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
	shop_item.modulate = Color(1.0, 1.0, 1.0, 1.0 if visible else 0.3)

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
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_mana_regen_upgrade_cost()
	carriage.upgrade_mana_regen()
	carriage.mana -= cost


func _on_ManaMaxShopItem2_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_mana_max_upgrade_cost()
	carriage.upgrade_mana_max()
	carriage.mana -= cost


func _on_SpellCostShopItem3_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_spell_cost_upgrade_cost()
	carriage.upgrade_spell_cost()
	carriage.mana -= cost

func _on_ShopItemNewBC_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_new_back_carrier_cost()
	if carriage.add_back_carrier():
		carriage.mana -= cost
		back_carrier_upgrade_locked = false

func _on_ShopItemUpBCL_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_back_carrier_life_upgrade_cost()
	carriage.upgrade_back_carrier_life()
	carriage.mana -= cost

func _on_ShopItemUpBCS_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_back_carrier_speed_upgrade_cost()
	carriage.upgrade_back_carrier_speed()
	carriage.mana -= cost

func _on_ShopItemNewFC_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_new_front_carrier_cost()
	if carriage.add_front_carrier():
		carriage.mana -= cost
		front_carrier_upgrade_locked = false

func _on_ShopItemUpFCL_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_front_carrier_life_upgrade_cost()
	carriage.upgrade_front_carrier_life()
	carriage.mana -= cost

func _on_ShopItemUpFCS_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_front_carrier_speed_upgrade_cost()
	carriage.upgrade_front_carrier_speed()
	carriage.mana -= cost

func _on_ShopItemNewLA_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_new_left_miner_cost()
	if carriage.add_left_miner():
		carriage.mana -= cost
		left_apprentice_upgrade_locked = false

func _on_ShopItemUpLAL_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_left_miner_life_upgrade_cost()
	carriage.upgrade_left_miner_life()
	carriage.mana -= cost

func _on_ShopItemNewRA_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_new_right_miner_cost()
	if carriage.add_right_miner():
		carriage.mana -= cost
		right_apprentice_upgrade_locked = false

func _on_ShopItemUpRAL_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	var cost = carriage.get_right_miner_life_upgrade_cost()
	carriage.upgrade_right_miner_life()
	carriage.mana -= cost


func _on_QuitButton_pressed():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BIP)
	Game.main_menu()
