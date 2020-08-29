extends Spatial

var is_open=false
export(bool) var is_locked=false
export(float) var open_angle=-145
export(Resource) var open_sound
export(Resource) var close_sound
export(NodePath) var audio_stream_path
var audio_stream

signal error_locked
var tween


func _ready():
	audio_stream=get_node(audio_stream_path)
	tween = $Tween as Tween
	tween.connect("tween_started", self, "on_animation_start")
	tween.connect("tween_all_completed", self, "on_animation_end")


func use(var close:bool=false):
	var hinge=$hinge as Spatial
	
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
	if close: is_open = false
	else: is_open = !is_open
	tween.start()


func on_animation_start(var object=null, var key=null):
	var sound=open_sound
	if !is_open: 
		sound=close_sound
	if sound!=null and audio_stream!=null:
		audio_stream.stream = sound
		audio_stream.play()
	pass

func on_animation_end(var object=null, var key=null ):
	if is_open:
		
		pass
	else:
		pass
	pass


func unlock():
	is_locked=false

func lock():
	is_locked=true
	use(true)
