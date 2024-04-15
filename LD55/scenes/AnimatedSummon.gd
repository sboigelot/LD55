extends Spatial

class_name AnimatedSummon

export var working_on_spawn = true
export var reset_working_on_work = false
var should_be_visible:bool = false
onready var working: bool = working_on_spawn

func _process(delta):
	
	if $AnimationPlayer.is_playing():
		if not should_be_visible and visible:
			if $AnimationPlayer.current_animation != "Despawn":
				$AnimationPlayer.stop(false)
		return
	
	if not should_be_visible and visible:
		$AnimationPlayer.playback_speed = 1.0
		$AnimationPlayer.play("Despawn")
		return
	
	if should_be_visible and not visible:
		$AnimationPlayer.playback_speed = 1.0
		$AnimationPlayer.play("Spawn")
		return
		
	if working and should_be_visible and visible:
		if $AnimationPlayer.has_animation("Work"):
			if reset_working_on_work:
				working = false
			var speed = Game.level.carriage.speed
			var normal_speed = 0.5
			$AnimationPlayer.playback_speed = min(1.0,max(5, speed / normal_speed))
			$AnimationPlayer.play("Work")
		return
