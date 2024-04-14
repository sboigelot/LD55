extends Spatial

class_name Carriage

export var starting_mana: float = 100.0
var mana: int

var distance_travelled: float
var speed: float
var back_carried: bool
var front_carried: bool

onready var body:Spatial = $Body

onready var front_carrier_visuals:Array = $FrontCarriers.get_children()
onready var front_carrier_max:int = front_carrier_visuals.size()
var front_carrier_lifes:Array = []
var front_carrier_base_cost: int = 10.0
var front_carrier_base_speed: float = 0.3
var front_carrier_speed_multipler: float = 1.0
var front_carrier_base_lifespan: float = 5.0
var front_carrier_lifespan_multipler: float = 1.0

onready var back_carrier_visuals:Array = $BackCarriers.get_children()
onready var back_carrier_max:int = back_carrier_visuals.size()
var back_carrier_lifes:Array = []
var back_carrier_base_cost: int = 10.0
var back_carrier_base_speed: float = 0.3
var back_carrier_speed_multipler: float = 1.0
var back_carrier_base_lifespan: float = 5.0
var back_carrier_lifespan_multipler: float = 1.0

onready var left_miner_visuals:Array = $LeftMiners.get_children()
onready var left_miner_max:int = left_miner_visuals.size()
var left_miner_lifes:Array = []
var left_miner_base_cost: int = 10.0
var left_miner_base_mining_speed: float = 1.0
var left_miner_base_mining_amount: int = 10.0
var left_miner_base_lifespan: float = 5.0
var left_miner_lifespan_multipler: float = 1.0

onready var right_miner_visuals:Array = $RightMiners.get_children()
onready var right_miner_max:int = right_miner_visuals.size()
var right_miner_lifes:Array = []
var right_miner_base_cost: int = 10.0
var right_miner_base_mining_speed: float = 1.0
var right_miner_base_mining_amount: int = 10.0
var right_miner_base_lifespan: float = 5.0
var right_miner_lifespan_multipler: float = 1.0
	
func _ready():
	mana = starting_mana
	distance_travelled = 0
	
func _process(delta):
	increase_summons_life(delta)
	expire_old_summons()
	update_visual_summons()
	calculate_speed()
	update_body_tilt_and_y()
	
func update_body_tilt_and_y():
	var carried_y = 0.75
	var not_carried_tilt = 0.0
	
	if not front_carried and not back_carried:
		body.translation.y = 0.0
#		body.rotation = Vector3.ZERO
		return
	
	if not front_carried and back_carried:
		body.translation.y = carried_y
#		body.rotate_z(-not_carried_tilt)
		return
		
	if front_carried and not back_carried:
		body.translation.y = carried_y
#		body.rotate_z(not_carried_tilt)
		return
	
func increase_summons_life(delta):
	var life = delta * Game.level.game_speed
	for i in front_carrier_lifes.size():
		front_carrier_lifes[i] += delta
		
	for i in back_carrier_lifes.size():
		back_carrier_lifes[i] += delta
		
	for i in left_miner_lifes.size():
		left_miner_lifes[i] += delta
		
	for i in right_miner_lifes.size():
		right_miner_lifes[i] += delta

func get_front_carrier_lifespan():
	return front_carrier_base_lifespan * (1.0 + front_carrier_lifespan_multipler)

func get_back_carrier_lifespan():
	return back_carrier_base_lifespan * (1.0 + back_carrier_lifespan_multipler)

func get_left_miner_lifespan():
	return left_miner_base_lifespan * (1.0 + left_miner_lifespan_multipler)

func get_right_miner_lifespan():
	return right_miner_base_lifespan * (1.0 + right_miner_lifespan_multipler)

func expire_old_summons():
	_expire_old_summons(front_carrier_lifes, get_front_carrier_lifespan())
	_expire_old_summons(back_carrier_lifes, get_back_carrier_lifespan())
	_expire_old_summons(left_miner_lifes, get_left_miner_lifespan())
	_expire_old_summons(right_miner_lifes, get_right_miner_lifespan())
	
func _expire_old_summons(summon_lifes, max_life): 
	var duplicate = summon_lifes.duplicate() 
	for i in duplicate.size():
		if duplicate[i] > max_life:
			front_carrier_lifes.erase(duplicate[i])
	
func update_visual_summons():
	for i in front_carrier_visuals.size():
		front_carrier_visuals[i].visible = i < front_carrier_lifes.size()
		
	for i in back_carrier_visuals.size():
		back_carrier_visuals[i].visible = i < back_carrier_lifes.size()
		
	for i in left_miner_visuals.size():
		left_miner_visuals[i].visible = i < left_miner_lifes.size()
		
	for i in right_miner_visuals.size():
		right_miner_visuals[i].visible = i < right_miner_lifes.size()
		
func calculate_speed():
	speed = ((front_carrier_lifes.size() * front_carrier_base_speed * front_carrier_speed_multipler) +
			(back_carrier_lifes.size() * back_carrier_base_speed * back_carrier_speed_multipler))

	front_carried = front_carrier_lifes.size() != 0
	if not front_carried:
		speed /= 2
		
	back_carried = back_carrier_lifes.size() != 0
	if not back_carried:
		speed /= 2
		
func add_front_carrier() -> bool:
	if front_carrier_lifes.size() >= front_carrier_max:
		return false
	front_carrier_lifes.append(0.0)
	return true

func add_back_carrier() -> bool:
	if back_carrier_lifes.size() >= back_carrier_max:
		return false
	back_carrier_lifes.append(0.0)
	return true
	
func add_left_miner() -> bool:
	if left_miner_lifes.size() >= left_miner_max:
		return false
	left_miner_lifes.append(0.0)
	return true
	
func add_right_miner() -> bool:
	if right_miner_lifes.size() >= right_miner_max:
		return false
	right_miner_lifes.append(0.0)
	return true


func get_new_front_carrier_cost() -> int:
	return int(round(front_carrier_base_cost * (1.0 + 0.5 * front_carrier_lifes.size())))
	
func get_front_carrier_life_upgrade_cost() -> int:
	return 100
	
func get_front_carrier_speed_upgrade_cost() -> int:
	return 100
	
func get_new_back_carrier_cost() -> int:
	return int(round(back_carrier_base_cost * (1.0 + 0.5 * back_carrier_lifes.size())))
	
func get_back_carrier_life_upgrade_cost() -> int:
	return 100
	
func get_back_carrier_speed_upgrade_cost() -> int:
	return 100
