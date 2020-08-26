extends KinematicBody

var can_move:bool = true
var camera_lock: bool = false
func set_camera_lock(): 
	can_move=false
	camera_lock=true
func clear_camera_lock(): 
	can_move=true
	camera_lock=false

var x:float = 0
var xSensitivity=0.01
var xJoySens=0.05
var x_deadzone=0.1

var BaseMoveSpeed:float = 0.05
var running:bool = false
var runMult:float = 2
var fallAccel:float = -0.01
var fallSpeed:float = 0

func CurrentMoveSpeed():
	if !running: return BaseMoveSpeed 
	else: return BaseMoveSpeed * runMult


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass

func _input(event):
	if not can_move: return
	if event is InputEventMouseMotion and not camera_lock:
		if(Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED): 
			var d = event.relative
			x-=d.x*xSensitivity
			update_facing()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not can_move: return
	var moveVector:Vector3
	var strafe:Vector3
	running=Input.is_action_pressed("run")
	if(Input.is_action_pressed("ui_up") || Input.is_action_pressed("move_forward")): 
		moveVector = global_transform.basis.z*-0.1
	if(Input.is_action_pressed("ui_down") || Input.is_action_pressed("move_back")): 
		moveVector = global_transform.basis.z*0.1
	if(Input.is_action_pressed("ui_left") || Input.is_action_pressed("move_left")): 
		strafe = global_transform.basis.z*0.1
		strafe.y=0
		strafe=strafe.rotated(Vector3(0,1,0),PI/2)*-1
	if(Input.is_action_pressed("ui_right") || Input.is_action_pressed("move_right")): 
		strafe = global_transform.basis.z*0.1
		strafe.y=0
		strafe=strafe.rotated(Vector3(0,1,0),PI/2)
	moveVector+=strafe
	moveVector.y=0
	moveVector=moveVector.normalized()*CurrentMoveSpeed()
	move_and_collide(moveVector)
	if(!$StairsFrontBack.is_colliding() && !$StairsLeftRight.is_colliding()):
		var r = move_and_collide(Vector3(0,fallAccel,0),true,true,true)
		if not r :
			fallSpeed+=fallAccel
			move_and_collide(Vector3(0,fallSpeed,0))
		else:
			fallSpeed=0
		
	if not camera_lock:
		var joyDelta:=Vector2(Input.get_joy_axis(0,2),Input.get_joy_axis(0,3))
		if abs(joyDelta.x)>x_deadzone:
			x-=joyDelta.x*xJoySens
			update_facing()

func update_facing():
	var b = Basis(Vector3(0,1,0),x)
	transform.basis = b
