extends Node

var current_world

var road_scenes:Dictionary = {
	"Base": preload("res://scenes/Roads/RoadBase.tscn")
}

func instanciate_road(parent:Spatial, clear_child:bool, road_type:String)->Spatial:
	if clear_child:
		for child in parent.get_children():
			child.queue_free()
	
	if not road_scenes.has(road_type):
		road_type = "Base"
		
	var road_scene = road_scenes[road_type]
	var instance = road_scene.instance()
	parent.add_child(instance)
	return instance