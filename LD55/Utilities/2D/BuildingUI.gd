extends Node2D

var selected_building_spatial
var world_anchor: Vector3

export(PackedScene) var building_site_scene
export(PackedScene) var farm_scene
export(PackedScene) var roaster_scene
export(PackedScene) var express_scene
export(PackedScene) var bombard_scene
export(PackedScene) var hotspot_scene

export(NodePath) var np_circle_texture_rect
export(NodePath) var np_farm_accu_button
export(NodePath) var np_roaster_accu_button
export(NodePath) var np_express_accu_button
export(NodePath) var np_bombard_accu_button
export(NodePath) var np_hotspot_accu_button
export(NodePath) var np_upgrade_accu_button
export(NodePath) var np_sell_accu_button

onready var circle_texture_rect = get_node(np_circle_texture_rect) as TextureRect
onready var farm_accu_button = get_node(np_farm_accu_button) as AccumulatorButton
onready var roaster_accu_button = get_node(np_roaster_accu_button) as AccumulatorButton
onready var express_accu_button = get_node(np_express_accu_button) as AccumulatorButton
onready var bombard_accu_button = get_node(np_bombard_accu_button) as AccumulatorButton
onready var hotspot_accu_button = get_node(np_hotspot_accu_button) as AccumulatorButton
onready var upgrade_accu_button = get_node(np_upgrade_accu_button) as AccumulatorButton
onready var sell_accu_button = get_node(np_sell_accu_button) as AccumulatorButton

const default_stay_visible_time:float = 5.0
var time_since_last_click:float = 0.0

func _ready():
	visible = false
	
func _process(delta):
	if not visible:
		return
		
	time_since_last_click += delta
	if time_since_last_click >= default_stay_visible_time:
		visible = false
		return
		
	move_and_show_at_world_anchor()

func popup_for_building(building_spatial:Spatial):
	time_since_last_click = 0.0
	if visible and selected_building_spatial == building_spatial:
		return
#	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BUTTON_PRESSED)
	world_anchor = building_spatial.translation
	selected_building_spatial = building_spatial
	update_ui()
	move_and_show_at_world_anchor()

func get_new_farm_cost(vary_count:int = 0) -> int:
	var farm_count = Game.level.get_all_farms().size()
	var farm_cost = Balance.farm_base_cost[0] * (1 + farm_count + vary_count)
	return farm_cost
	
func get_new_roaster_cost(vary_count:int = 0) -> int:
	var roaster_count = Game.level.get_all_roasters().size()
	var roaster_cost = Balance.roaster_base_cost[0] * (1 + roaster_count + vary_count)
	return roaster_cost

func get_sell_value(building_spatial)->int:
	if building_spatial == null:
		return 0
		
	if building_spatial is Farm:
		return get_new_farm_cost(-1) / 2
		
	if building_spatial is Roaster:
		return get_new_roaster_cost(-1) / 2
		
	if building_spatial is ExpressTower:
		return Balance.express_base_cost[building_spatial.level - 1] / 2
		
	if building_spatial is BombardTower:
		return Balance.bombard_base_cost[building_spatial.level - 1] / 2
		
	if building_spatial is HotSpotTower:
		return Balance.hotspot_base_cost[building_spatial.level - 1] / 2
		
	return 0

func update_ui():
	if selected_building_spatial == null:
		hide()
		
	var empty_site = selected_building_spatial is BuildingSite
	
	var farm_cost = get_new_farm_cost()
	farm_accu_button.text = "Farm\n%d" % farm_cost
	farm_accu_button.disabled = Game.level.coins < farm_cost
	
	var roaster_cost = get_new_roaster_cost()
	roaster_accu_button.text = "Roaster\n%d" % roaster_cost
	roaster_accu_button.disabled = Game.level.coins < roaster_cost
	
	express_accu_button.text = "Express\n%d" % Balance.express_base_cost[0]
	bombard_accu_button.text = "Bombard\n%d" % Balance.bombard_base_cost[0]
	hotspot_accu_button.text = "Hotspot\n%d" % Balance.hotspot_base_cost[0]
	
	express_accu_button.disabled = Game.level.coins < Balance.express_base_cost[0]
	bombard_accu_button.disabled = Game.level.coins < Balance.bombard_base_cost[0]
	hotspot_accu_button.disabled = Game.level.coins < Balance.hotspot_base_cost[0]
	
	farm_accu_button.visible = empty_site and Game.player_data.unlocked_farm_level > 0
	roaster_accu_button.visible = empty_site and Game.player_data.unlocked_roaster_level > 0
	express_accu_button.visible = empty_site and Game.player_data.unlocked_express_level > 0
	bombard_accu_button.visible = empty_site and Game.player_data.unlocked_bombard_level > 0
	hotspot_accu_button.visible = empty_site and Game.player_data.unlocked_hotspot_level > 0
	
	sell_accu_button.visible = not empty_site and not Game.level is TutorialLevel
	var sell_value = get_sell_value(selected_building_spatial)
	sell_accu_button.text = "Sell\n%d" % sell_value
	
	var upgradable = (not Game.level is TutorialLevel and
						selected_building_spatial != null and 
						not selected_building_spatial is BuildingSite and 
						selected_building_spatial.upgrade_cost != 0 and 
						selected_building_spatial.upgrade_to_scene != null)
	
	if upgradable:
		var unlocked_level = 0
		if selected_building_spatial is Farm:
			unlocked_level = Game.player_data.unlocked_farm_level
		elif selected_building_spatial is Roaster:
			unlocked_level = Game.player_data.unlocked_roaster_level
		elif selected_building_spatial is ExpressTower:
			unlocked_level = Game.player_data.unlocked_express_level
		elif selected_building_spatial is BombardTower:
			unlocked_level = Game.player_data.unlocked_bombard_level
		elif selected_building_spatial is HotSpotTower:
			unlocked_level = Game.player_data.unlocked_hotspot_level
		
		upgradable = unlocked_level and selected_building_spatial.level < unlocked_level
	
	sell_accu_button.rect_position = Vector2(32 if upgradable else -32, 64)
	
	upgrade_accu_button.visible = upgradable
	if upgradable:
		upgrade_accu_button.text = "Upgrade\n%d" % selected_building_spatial.upgrade_cost
		upgrade_accu_button.disabled = Game.level.coins < selected_building_spatial.upgrade_cost
		
	farm_accu_button.update_ui()
	roaster_accu_button.update_ui()
	express_accu_button.update_ui()
	bombard_accu_button.update_ui()
	hotspot_accu_button.update_ui()
	upgrade_accu_button.update_ui()
	sell_accu_button.update_ui()

	circle_texture_rect.visible = roaster_accu_button.visible or farm_accu_button.visible
		
func move_and_show_at_world_anchor():
	var position2d = Game.level.ui.postion3d_to_screen(world_anchor)
	position = position2d
	visible = true

func _input(event):
	if not visible:
		return
		
	if (event is InputEventMouseButton and 
		event.pressed):
		if not capture_mouse_position(event.position):
			hide()

func capture_mouse_position(position:Vector2):
	if (selected_building_spatial != null and
		selected_building_spatial.mouse_over):
			return true
			
	var capture_controls = [
		circle_texture_rect,
		farm_accu_button,
		roaster_accu_button,
		express_accu_button,
		bombard_accu_button,
		hotspot_accu_button,
		upgrade_accu_button,
	]
	
	for capture_control in capture_controls:
		var rect = capture_control.get_global_rect()
		if rect.has_point(position):
			return true
	
	return false

func _on_FarmAccumulatorButton_accumulated():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.CONSTRUCTION)
	var farm_cost = get_new_farm_cost()
	Game.level.coins -= farm_cost
	selected_building_spatial = Game.level.replace_building(selected_building_spatial, farm_scene)
	update_ui()
	
func _on_OverAccumulatorButton_accumulated():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.CONSTRUCTION)
	var roaster_cost = get_new_roaster_cost()
	Game.level.coins -= roaster_cost
	Game.level.ui.spawn_coin_floating_label("%+d" % roaster_cost, Color.red)
	selected_building_spatial = Game.level.replace_building(selected_building_spatial, roaster_scene)
	update_ui()

func _on_ExpressAccumulatorButton_accumulated():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.CONSTRUCTION)
	Game.level.coins -= Balance.express_base_cost[0]
	Game.level.ui.spawn_coin_floating_label("%+d" % Balance.express_base_cost[0], Color.red)
	selected_building_spatial = Game.level.replace_building(selected_building_spatial, express_scene)
	update_ui()

func _on_BombardAccumulatorButton_accumulated():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.CONSTRUCTION)
	Game.level.coins -= Balance.bombard_base_cost[0]
	Game.level.ui.spawn_coin_floating_label("%+d" % Balance.bombard_base_cost[0], Color.red)
	selected_building_spatial = Game.level.replace_building(selected_building_spatial, bombard_scene)
	update_ui()

func _on_HotSpotAccumulatorButton_accumulated():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.CONSTRUCTION)
	Game.level.coins -= Balance.hotspot_base_cost[0]
	Game.level.ui.spawn_coin_floating_label("%+d" % Balance.hotspot_base_cost[0], Color.red)
	selected_building_spatial = Game.level.replace_building(selected_building_spatial, hotspot_scene)
	update_ui()

func _on_UpgradeAccumulatorButton_accumulated():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.CONSTRUCTION)
	Game.level.coins -= selected_building_spatial.upgrade_cost
	Game.level.ui.spawn_coin_floating_label("%+d" % selected_building_spatial.upgrade_cost, Color.red)
	selected_building_spatial = Game.level.replace_building(selected_building_spatial, selected_building_spatial.upgrade_to_scene)
	update_ui()

func _on_SellAccumulatorButton_accumulated():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.COINS_LARGE)
	var sell_value = get_sell_value(selected_building_spatial)
	Game.level.coins += sell_value
	Game.level.ui.spawn_coin_floating_label("%+d" % sell_value, Color.lime)
	selected_building_spatial = Game.level.replace_building(selected_building_spatial, building_site_scene)
	selected_building_spatial._on_show_building_ui(selected_building_spatial)
	update_ui()


func _on_FarmAccumulatorButton_clicked():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BUTTON_PRESSED)

func _on_OverAccumulatorButton_clicked():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BUTTON_PRESSED)

func _on_ExpressAccumulatorButton_clicked():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BUTTON_PRESSED)
	
func _on_BombardAccumulatorButton_clicked():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BUTTON_PRESSED)
	
func _on_HotSpotAccumulatorButton_clicked():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BUTTON_PRESSED)

func _on_UpgradeAccumulatorButton_clicked():
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.BUTTON_PRESSED)
