extends Spatial

class_name AnimatedSummon

var should_be_visible:bool = false

func _process(delta):
	
	if $AnimationPlayer.is_playing():
		return
	
	if not should_be_visible and visible:
		$AnimationPlayer.play("Despawn")
		return
	
	if should_be_visible and not visible:
		$AnimationPlayer.play("Spawn")
		return
