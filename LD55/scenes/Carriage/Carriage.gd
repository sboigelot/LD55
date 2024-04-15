extends Spatial

class_name Carriage

var mana: float = 10.0
var mana_max: int = 100
var mana_max_upgrade_base_cost = 30.0
var mana_regen: float = 2.0
var mana_regen_upgrade_base_cost: float = 10.0
var spell_cost: float = 1.0
var spell_cost_upgrade_base_cost: float = 75.0
	
var distance_travelled: float = 0.0
var speed: float
var back_carried: bool
var front_carried: bool

onready var body:Spatial = $Body
onready var body_animation_player:AnimationPlayer = $Body/AnimationPlayer
var previously_played_body_animation = ""

onready var front_carrier_visuals:Array = $FrontCarriers.get_children()
var front_carrier_lifes:Array = []
var front_carrier_base_cost: int = 10
var front_carrier_base_speed: float = 0.4
var front_carrier_speed_upgrade_base_cost:int = 25
var front_carrier_speed_multipler: float = 1.0
var front_carrier_base_lifespan: float = 20.0
var front_carrier_lifespan_upgrade_base_cost:int = 25
var front_carrier_lifespan_multipler: float = 1.0

onready var back_carrier_visuals:Array = $BackCarriers.get_children()
var back_carrier_lifes:Array = []
var back_carrier_base_cost: int = 10
var back_carrier_base_speed: float = 0.4
var back_carrier_speed_upgrade_base_cost:int = 25
var back_carrier_speed_multipler: float = 1.0
var back_carrier_base_lifespan: float = 20.0
var back_carrier_lifespan_upgrade_base_cost:int = 25
var back_carrier_lifespan_multipler: float = 1.0

onready var left_miner_visuals:Array = $LeftMiners.get_children()
var left_miner_lifes:Array = []
var left_miner_base_cost: int = 10.0
var left_miner_base_mining_speed: float = 1.0
var left_miner_base_mining_amount: int = 10.0
var left_miner_base_lifespan: float = 10.0
var left_miner_upgrade_base_cost: int = 25
var left_miner_lifespan_multipler: float = 1.0

onready var right_miner_visuals:Array = $RightMiners.get_children()
var right_miner_lifes:Array = []
var right_miner_base_cost: int = 10.0
var right_miner_base_mining_speed: float = 1.0
var right_miner_base_mining_amount: int = 10.0
var right_miner_base_lifespan: float = 10.0
var right_miner_upgrade_base_cost: int = 25
var right_miner_lifespan_multipler: float = 1.0

func _ready():
	init_summons_lifes()
	
func init_summons_lifes():
	for i in front_carrier_visuals:
		front_carrier_lifes.append(-1.0)
		
	for i in back_carrier_visuals:
		back_carrier_lifes.append(-1.0)
		
	for i in left_miner_visuals:
		left_miner_lifes.append(-1.0)
		
	for i in right_miner_visuals:
		right_miner_lifes.append(-1.0)
	
func _process(delta):
	
	if Game.level.is_paused():
		return
	
	regen_mana(delta)
	increase_summons_life(delta)
	expire_old_summons()
	update_visual_summons()
	calculate_speed()
	update_body_tilt_and_y()

func increase_summons_life(delta):
	var life = delta * Game.level.game_speed
	for i in front_carrier_lifes.size():
		if front_carrier_lifes[i] >= 0.0:
			front_carrier_lifes[i] += delta
		
	for i in back_carrier_lifes.size():
		if back_carrier_lifes[i] >= 0.0:
			back_carrier_lifes[i] += delta
		
	for i in left_miner_lifes.size():
		if left_miner_lifes[i] >= 0.0:
			left_miner_lifes[i] += delta
		
	for i in right_miner_lifes.size():
		if right_miner_lifes[i] >= 0.0:
			right_miner_lifes[i] += delta
		
func expire_old_summons():
	_expire_old_summons(front_carrier_lifes, get_front_carrier_lifespan())
	_expire_old_summons(back_carrier_lifes, get_back_carrier_lifespan())
	_expire_old_summons(left_miner_lifes, get_left_miner_lifespan())
	_expire_old_summons(right_miner_lifes, get_right_miner_lifespan())
	
func _expire_old_summons(summon_lifes, max_life): 
	for i in summon_lifes.size():
		if summon_lifes[i] > max_life:
			summon_lifes[i] = -1.0
			
func update_visual_summons_list(visuals:Array, lifes:Array, parent:Spatial):
	for i in visuals.size():
		var visible_last_update = visuals[i].should_be_visible
		visuals[i].should_be_visible = lifes[i] >= 0
		
func update_visual_summons():
	
	update_visual_summons_list(front_carrier_visuals,
								front_carrier_lifes,
								$FrontCarriers)
								
	update_visual_summons_list(back_carrier_visuals,
								back_carrier_lifes,
								$BackCarriers)
								
	update_visual_summons_list(left_miner_visuals,
								left_miner_lifes,
								$LeftMiners)
								
	update_visual_summons_list(right_miner_visuals,
								right_miner_lifes,
								$RightMiners)
func regen_mana(delta):
	mana += mana_regen * delta
	mana = min(mana, mana_max)

func single_play_body_animation(animation_name):
	if previously_played_body_animation == animation_name:
		return
		
	previously_played_body_animation = animation_name
	body_animation_player.play(animation_name)

func update_body_tilt_and_y():
	var carried_y = 0.75
	var not_carried_tilt = 0.0
	
	if not front_carried and not back_carried:
		single_play_body_animation("FallToGround")
		return
	
	if not front_carried and back_carried:
		single_play_body_animation("TiltFront")
		return
		
	if front_carried and not back_carried:
		single_play_body_animation("TiltBack")
		return
	
	single_play_body_animation("RESET")

func get_front_carrier_lifespan():
	return front_carrier_base_lifespan * front_carrier_lifespan_multipler

func get_back_carrier_lifespan():
	return back_carrier_base_lifespan * back_carrier_lifespan_multipler

func get_left_miner_lifespan():
	return left_miner_base_lifespan * left_miner_lifespan_multipler

func get_right_miner_lifespan():
	return right_miner_base_lifespan * right_miner_lifespan_multipler
	
func get_front_carrier_speed() -> float:
	return front_carrier_base_speed * front_carrier_speed_multipler
	
func get_back_carrier_speed() -> float:
	return back_carrier_base_speed * back_carrier_speed_multipler
	
func calculate_speed():
	speed = 0.0
	
	front_carried = false
	var front_carrier_speed = get_front_carrier_speed()
	for i in front_carrier_lifes.size():
		if front_carrier_lifes[i] >= 0.0:
			speed += front_carrier_speed
			front_carried = true
	
	back_carried = false
	var back_carrier_speed = get_back_carrier_speed()
	for i in back_carrier_lifes.size():
		if back_carrier_lifes[i] >= 0.0:
			speed += back_carrier_speed
			back_carried = true

	if not front_carried:
		speed /= 2
		
	if not back_carried:
		speed /= 2

func can_add_front_carrier() -> bool:
	for i in front_carrier_lifes.size():
		if front_carrier_lifes[i] < 0.0:
			return true
	return false
	
func add_front_carrier() -> bool:
	if not can_add_front_carrier():
		return false
	for i in front_carrier_lifes.size():
		if front_carrier_lifes[i] < 0.0:
			front_carrier_lifes[i] = 0.0
			return true
	return false
	
func can_add_back_carrier() -> bool:
	for i in back_carrier_lifes.size():
		if back_carrier_lifes[i] < 0.0:
			return true
	return false
	
func add_back_carrier() -> bool:
	if not can_add_back_carrier():
		return false
	for i in front_carrier_lifes.size():
		if back_carrier_lifes[i] < 0.0:
			back_carrier_lifes[i] = 0.0
			return true
	return false

func can_add_left_miner() -> bool:
	for i in left_miner_lifes.size():
		if left_miner_lifes[i] < 0.0:
			return true
	return false
	
func add_left_miner() -> bool:
	if not can_add_left_miner():
		return false
	for i in front_carrier_lifes.size():
		if left_miner_lifes[i] < 0.0:
			left_miner_lifes[i] = 0.0
			return true
	return false

func can_add_right_miner() -> bool:
	for i in right_miner_lifes.size():
		if right_miner_lifes[i] < 0.0:
			return true
	return false
	
func add_right_miner() -> bool:
	if not can_add_right_miner():
		return false
	for i in right_miner_lifes.size():
		if right_miner_lifes[i] < 0.0:
			right_miner_lifes[i] = 0.0
			return true
	return false

func upgrade_front_carrier_speed():
	front_carrier_speed_multipler += 0.25
	
func upgrade_front_carrier_life():
	front_carrier_lifespan_multipler += 0.25

func count_alive(lifes) -> int:
	var count = 0
	for i in lifes.size():
		if lifes[i] >= 0.0:
			count += 1
	return count

func get_front_carrier_count() -> int:
	return count_alive(front_carrier_lifes)

func get_new_front_carrier_cost() -> int:
	var count = get_front_carrier_count()
	var cost = front_carrier_base_cost * (1.0 + 0.5 * count)
	return int(round(cost * spell_cost))
	
func get_front_carrier_speed_upgrade_cost() -> int:
	var cost = front_carrier_speed_upgrade_base_cost * front_carrier_speed_multipler
	return int(round(cost * spell_cost))
	
func get_front_carrier_life_upgrade_cost() -> int:
	var cost = front_carrier_lifespan_upgrade_base_cost * front_carrier_lifespan_multipler
	return int(round(cost * spell_cost))
	
func upgrade_mana_regen():
	mana_regen += 1
	
func upgrade_mana_max():
	mana_max += 100
	
func upgrade_spell_cost():
	spell_cost *= 0.9
	
func upgrade_back_carrier_speed():
	back_carrier_speed_multipler += 0.25
	
func upgrade_back_carrier_life():
	back_carrier_lifespan_multipler += 0.25
	
func upgrade_left_miner_life():
	left_miner_lifespan_multipler += 0.25
	
func upgrade_right_miner_life():
	right_miner_lifespan_multipler += 0.25
	
func get_mana_max_upgrade_cost() -> int:
	var cost = 	(mana_max_upgrade_base_cost * 
					(mana_max / 100) 
				)
	return int(round(cost * spell_cost))
	
func get_mana_regen_upgrade_cost() -> int:
	var cost = 	(mana_regen_upgrade_base_cost * 
					mana_regen * 
					mana_regen)
	return int(round(cost * spell_cost))
	
func get_spell_cost_upgrade_cost() -> int:
	var e = 1.0 + abs(spell_cost - 1.0)
	var cost = 	(spell_cost_upgrade_base_cost * 
					e * e)
	return int(round(cost))
	
func get_back_carrier_count() -> int:
	return count_alive(back_carrier_lifes)

func get_new_back_carrier_cost() -> int:
	var count = get_back_carrier_count()
	var cost = back_carrier_base_cost * (1.0 + 0.5 * count)
	return int(round(cost * spell_cost))
	
func get_back_carrier_life_upgrade_cost() -> int:
	var cost = back_carrier_lifespan_upgrade_base_cost * back_carrier_lifespan_multipler
	return int(round(cost * spell_cost))
	
func get_back_carrier_speed_upgrade_cost() -> int:
	var cost = back_carrier_speed_upgrade_base_cost * back_carrier_speed_multipler
	return int(round(cost * spell_cost))

func get_left_miner_count() -> int:
	return count_alive(left_miner_lifes)

func get_new_left_miner_cost() -> int:
	var count = get_left_miner_count()
	var cost = left_miner_base_cost * (1.0 + 0.5 * count)
	return int(round(cost * spell_cost))
	
func get_right_miner_count() -> int:
	return count_alive(right_miner_lifes)

func get_new_right_miner_cost() -> int:
	var count = get_right_miner_count()
	var cost = right_miner_base_cost * (1.0 + 0.5 * count)
	return int(round(cost * spell_cost))

func get_left_miner_life_upgrade_cost() -> int:
	var cost = left_miner_upgrade_base_cost * left_miner_lifespan_multipler
	return int(round(cost * spell_cost))
	
func get_right_miner_life_upgrade_cost() -> int:
	var cost = right_miner_upgrade_base_cost * right_miner_lifespan_multipler
	return int(round(cost * spell_cost))

func on_gem_reach_carriage(gem:Gem):
	var is_gem_left = gem.translation.z > 0
	
	if is_gem_left:
		if get_left_miner_count() > 0:
			mine_gem(gem, left_miner_visuals[0].translation)
			left_miner_visuals[0].working = true
			return
		return
	
	if get_right_miner_count() > 0:
		mine_gem(gem, right_miner_visuals[0].translation)
		right_miner_visuals[0].working = true
		return

func mine_gem(gem:Gem, position3d:Vector3):
	SfxManager.play_from_group(SfxManager.SOUND_GROUP.DING)
	var mana_generated = gem.mana_stored - gem.mana_mined
	gem.queue_free()
	Game.level.generate_mana(mana_generated)
	Game.level.spawn_floating_label_3d(position3d, "+%d mana" % mana_generated)
	
