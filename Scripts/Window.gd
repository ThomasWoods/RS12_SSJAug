extends Spatial

var is_open=false
export(bool) var is_locked=false
export(float) var open_y=0.6

signal error_locked

func use(var close:bool=false):
	var LowerPane=$LowerPane as Spatial
	var tween=$Tween
	
	if is_locked and not close:
		emit_signal("error_locked")
		return
		
	var target=open_y
	if is_open or close: 
		target=0
	var current_t=LowerPane.translation
	var target_t=Vector3(current_t.x,target,current_t.z)

	tween.interpolate_property(LowerPane, "translation",
		current_t, 
		target_t, 
		0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	if close: is_open = false
	else: is_open = !is_open

func unlock():
	is_locked=false
func lock():
	is_locked=true
	use(true)
