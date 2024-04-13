extends Spatial

class_name Carriage

export var starting_mana: float = 10.0

var mana: int

var distance_travelled: float
var speed: float

func ready():
	mana = starting_mana
	distance_travelled = 0
	
func _process(delta):
	calculate_speed()
	
func calculate_speed():
	speed = 0.0
	
func get_front_carriers()->Array:
	return []
	
func get_back_carriers()->Array:
	return []
	
func get_gem_miners()->Array:
	return []
