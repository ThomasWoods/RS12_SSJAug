extends Spatial

var is_open=false
export(bool) var is_locked=false
export(float) var open_angle=-145

signal error_locked

func use(var close:bool=false):
	var hinge=$hinge as Spatial
	var tween=$Tween
	
	if is_locked and not close:
		emit_signal("error_locked")
		return
		
	var target=open_angle
	if is_open or close: 
		target=0
	var current_rot=hinge.rotation_degrees
	var target_rot=Vector3(0,target,0)

	tween.interpolate_property(hinge, "rotation_degrees",
		current_rot, 
		target_rot, 
		1,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	is_open=!is_open

func unlock():
	is_locked=false
func lock():
	is_locked=true
	use(true)
