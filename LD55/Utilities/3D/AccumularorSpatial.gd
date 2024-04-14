extends ClickableSpatial

class_name AccumularorSpatial

signal accumulated(clickable, position)

export var accumulated_value: float = 0.0
export var click_value: float = 1.0
export var target_value: float = 3.0
export var decay_amount: float = 1.0
export var click_protect_duration: float = 0.5
export var decay_protect_duration: float = 0.5
export var decay_speed_independent_from_timescale: bool = false

var time_since_last_decay: float
var time_since_last_click: float

func _ready():
	if not is_connected("click", self, "on_click"):
		connect("click", self, "on_click")

func get_click_value_with_bonus() -> float:
	return click_value

func on_click(clickable, position, is_human):
	time_since_last_click = 0
	accumulated_value += get_click_value_with_bonus()
	if accumulated_value <= target_value:
		return
	
	accumulated_value = 0
	time_since_last_decay = 0
	emit_signal("accumulated", self, position)

func _process(delta):
	if Game.pause:
		return
	
	deaccumulate(delta)
	
func deaccumulate(delta):
	var real_delta = delta
	if decay_speed_independent_from_timescale:
		if Engine.time_scale != 1.0:
			real_delta = delta / Engine.time_scale
			
	time_since_last_click += delta
	if time_since_last_click <= click_protect_duration:
		return
	
	if accumulated_value <= 0:
		return
	
	time_since_last_decay += delta
	if time_since_last_decay <= decay_protect_duration:
		return
		
	time_since_last_decay = 0
	accumulated_value = max(0, accumulated_value - decay_amount)
