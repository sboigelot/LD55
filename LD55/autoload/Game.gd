extends Node

var level

var road_scenes:Dictionary = {
	"Base": preload("res://scenes/Roads/RoadBase.tscn"),
	"Gem1": preload("res://scenes/Roads/RoadGem1.tscn"),
	"Gem2": preload("res://scenes/Roads/RoadGem2.tscn"),
	"Shrine1": preload("res://scenes/Roads/RoadShrine1.tscn"),
	"End": preload("res://scenes/Roads/RoadEnd.tscn"),
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
