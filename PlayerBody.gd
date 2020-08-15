extends KinematicBody

export(NodePath) var textNode
var textLabel:RichTextLabel
var msg:String = "" setget setText, getText

func setText(var value):
	msg=String(value)
	textLabel.text=msg
func getText():
	return msg

func m(var s):
	self.msg=s


var x:float = 0
var xSensitivity=0.01

var BaseMoveSpeed:float = 0.05
var running:bool = false
var runMult:float = 2
var fallSpeed:float = -0.1

func CurrentMoveSpeed():
	if !running: return BaseMoveSpeed 
	else: return BaseMoveSpeed * runMult


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	textLabel = get_node(textNode)
	
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		if(Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED): 
			var d = event.relative
			x-=d.x*xSensitivity
			var b = Basis(Vector3(0,1,0),x)
			transform.basis = b
#	if event is InputEventAction:
#		event.action
#		if event.pressed && event.action=="ui_cancel":
#			self.mouseCaptured=!mouseCaptured
#		if event.pressed && event.action=="ui_up":
#			m("up")
		 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
		move_and_collide(Vector3(0,fallSpeed,0))

