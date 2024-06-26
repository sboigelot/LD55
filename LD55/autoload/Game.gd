extends Node

export var transition_colors:PoolColorArray

var level

var road_scenes:Dictionary = {
	"Base1": preload("res://Scenes/Roads/RoadBase1.tscn"),
	"Base2": preload("res://Scenes/Roads/RoadBase2.tscn"),
	"Gem1": preload("res://Scenes/Roads/RoadGem1.tscn"),
	"Gem2": preload("res://Scenes/Roads/RoadGem2.tscn"),
	"Shrine1": preload("res://Scenes/Roads/RoadShrine1.tscn"),
	"End": preload("res://Scenes/Roads/RoadEnd.tscn"),
}

func instanciate_road(parent:Spatial, clear_child:bool, road_type:String)->Spatial:
	if clear_child:
		for child in parent.get_children():
			child.queue_free()
	
	if not road_scenes.has(road_type):
		road_type = "Base1"
		
	var road_scene = road_scenes[road_type]
	var instance = road_scene.instance()
	parent.add_child(instance)
	return instance

func restart():
	Game.transition_to_scene("res://Scenes/Level.tscn")

func main_menu():
	Game.transition_to_scene("res://Scenes/MainMenu.tscn")
	
func transition_to_scene(scene_path):
	var textures = [
		load("res://Utilities/SceneTransition/Transitions/transition-texture.png"),
		load("res://Utilities/SceneTransition/Transitions/middle_strip.png")
	]

	var color_index = randi() % transition_colors.size()
	var texture_index = randi() % textures.size()
	ScreenTransition.set_transition_color(transition_colors[color_index])
	ScreenTransition.set_transition_texture(textures[texture_index])
	ScreenTransition.transition_to_scene(scene_path)

func quit():
	if OS.has_feature("HTML5"):
		OS.window_fullscreen = false
	else:
		get_tree().quit()
