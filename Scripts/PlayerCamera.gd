extends Camera

var tween:Tween

var free_look = true 
var target:Node = null setget set_target

export var mouseCaptured=true setget setCameraMode, getCameraMode
var y:float = 0
var ySensitivity=0.01

var yJoySens=0.05
var y_deadzone=0.1

var y_min=-1.4
var y_max=1.3

var focus_speed=1
var return_speed=0.25

var first_event=true
var last_press=false

signal lock_camera
signal reset_camera_complete

func _ready():
	tween=$Tween


func _process(delta):
	if free_look:
		var joyDelta:=Vector2(Input.get_joy_axis(0,2),Input.get_joy_axis(0,3))
		if abs(joyDelta.y)>y_deadzone:
			y-=joyDelta.y*yJoySens
			update_facing()


func _input(event):
	if mouseCaptured: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if first_event:
		first_event=false
	if event.is_action_pressed("ui_cancel") and !last_press: 
		last_press=true
		#if(!mouseCaptured): Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#else: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouseCaptured=!mouseCaptured
	if event.is_action_released("ui_cancel"): 
		last_press=false
	if event is InputEventMouseMotion and free_look:
		if(Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED):
			y-=event.relative.y*ySensitivity 
			update_facing()
	#if event is InputEventJoypadMotion and free_look:

func update_facing():
	if(y<y_min): y=y_min
	if(y>y_max): y=y_max
	var b = Basis(Vector3(1,0,0),y)
	transform.basis = b


func setCameraMode(var value):
	#if(value): Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#else: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouseCaptured=value

func getCameraMode():
	return mouseCaptured


func set_target(var t):
	target = t as Spatial
	if target!=null:
		emit_signal("lock_camera")
		var current_basis=transform.basis
		look_at(target.global_transform.origin,Vector3.UP)
		var target_basis = transform.basis
		transform.basis = current_basis
		tween.interpolate_property(self, "transform:basis",
			transform.basis, target_basis, focus_speed,
			Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()

func reset_camera():
	target=null
	free_look=false
	tween.interpolate_property(self, "transform:basis",
		transform.basis, Basis(Vector3(1,0,0),y), return_speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	tween.connect("tween_all_completed", self, "reset_camera_end")

func reset_camera_end():
	free_look=true
	tween.disconnect("tween_all_completed", self, "reset_camera_end")
	emit_signal("reset_camera_complete")
