extends Spatial

class_name Actor

signal destination_reached(actor)

export var speed:float = 3.0
export var turn_speed:float = 1.0

var destination_reached: bool = false
export var destination: Vector3
export var destination_snap_distance: float = 0.1

func get_next_destination():
	destination_reached = true
	return
		
func _process(delta):
	if Game.pause:
		return
		
	if destination_reached:
		return
		
	if move_toward_destination(destination, delta):
		get_next_destination()
		
	if destination_reached:
		emit_signal("destination_reached", self)

func get_upgraded_speed() -> float:
	return speed
	
func move_toward_destination(destination:Vector3, delta:float) -> bool:
	var distance = translation.distance_to(destination)
	if distance < destination_snap_distance:
		return true
	
	rotation_degrees.y =  lerp(rotation_degrees.y,
				rad2deg(translation.angle_to(destination)), turn_speed * delta)

	look_at(destination, Vector3.UP)
	var direction = translation.direction_to(destination)
	var actual_speed =  get_upgraded_speed() * delta
	actual_speed = min(actual_speed, translation.distance_to(destination))
	translation += direction * actual_speed
	return false

