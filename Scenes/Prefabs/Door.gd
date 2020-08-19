extends Spatial

var is_open=false

func use():
	var tween=$Tween
	var target=-145
	if is_open: 
		target=0
	var current_rot=rotation_degrees
	var target_rot=Vector3(0,target,0)

	tween.interpolate_property(self, "rotation_degrees",
		current_rot, 
		target_rot, 
		1,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	is_open=!is_open


func _on_door_interacted_with():
	use()
	pass # Replace with function body.
