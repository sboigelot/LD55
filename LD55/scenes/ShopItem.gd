tool
extends MarginContainer

class_name ShopItem

signal pressed

export var title:String setget set_title
export var info:String setget set_info
export var mana_cost:int setget set_mana_cost
export var background_color:Color = Color.white setget set_background_color

export var tooltip:String 
export var disabled:bool setget set_disabled
var has_mana:bool = true

export(NodePath) var np_background
export(NodePath) var np_title_label
export(NodePath) var np_info_label
export(NodePath) var np_buy_button
export(NodePath) var np_cost_label

func set_title(value):
	title = value
	var label = get_node_or_null(np_title_label) as Label
	if label != null:
		label.text = title
	
func set_info(value):
	info = value
	var label = get_node_or_null(np_info_label) as Label
	if label != null:
		label.text = info
		
func set_disabled(value):
	disabled = value
	update_button()
		
func set_mana_cost(value):
	mana_cost = value
	update_button()
	
func set_background_color(value):
	background_color = value
	var background = get_node_or_null(np_background) as Container
	if background != null:
		background.self_modulate = value

func update_button():
	var button = get_node_or_null(np_buy_button) as Button
	if button != null:
		button.disabled = disabled or not has_mana

	var label = get_node_or_null(np_cost_label) as Label
	if label != null:
		label.text = ("%d" % [mana_cost]) if not disabled else "MAX"
		

func _on_BuyButton_pressed():
	if Game.level.is_paused():
		return
	emit_signal("pressed")
	
func _process(delta):
	if Engine.editor_hint:
		return
	
	has_mana = Game.level.carriage.mana >= mana_cost
	update_button()
	
