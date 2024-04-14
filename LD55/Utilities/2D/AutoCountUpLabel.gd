extends Label

signal ended

export var started:bool = false
export var duration:float = 5.0
export var start_value:int = 0.0
export var end_value:int = 0.0
export var count_up_curve:Curve

var current_value:int = 0
var ended:bool = false
var time_since_start:float = 0.0

func _ready():
	current_value = start_value
	text = "%d" % current_value

func start():
	time_since_start = 0.0
	ended = false
	started = true

func _process(delta):
	if ended:
		return
		
	if not started:
		text = "%d" % current_value
		return
	
	time_since_start += delta
	var percent = time_since_start / duration
	if percent > 1.0:
		ended = true
		emit_signal("ended")
		return
		
	current_value = int(round(start_value + count_up_curve.interpolate(percent) * (end_value - start_value)))
	text = "%d" % current_value
