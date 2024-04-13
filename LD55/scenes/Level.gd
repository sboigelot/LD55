extends Spatial

class_name Level

export(Array, String) var road_layout = [
	"Base", 
	"Gem1",
	"Base"
]

var game_speed: float =  1.0

onready var debug_rtb = $MarginContainer/PanelContainer/DebugRichTextLabel
onready var carriage:Carriage = $Carriage

func is_paused()->bool:
	return game_speed == 0

func _ready():
#	load_initial_roads()
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
	var test_carriage_speed = 3.0
	var roads = $Roads.get_children()
	for road in roads:
		road.translation.x -= delta * test_carriage_speed
		if road.translation.x < - 25.0:
			road.translation.x += roads.size() * 25.0
			if not load_next_road(road):
				game_speed = 0.0
				victory()

func victory():
	pass

func update_ui():
	debug_rtb.bbcode_text = "[b]mana:[/b] %d" % [carriage.mana]
