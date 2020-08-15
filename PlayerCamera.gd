extends Camera

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


export var mouseCaptured=true setget setCameraMode, getCameraMode

var y:float = 0
var ySensitivity=0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	textLabel = get_node(textNode)
	m("Welcome!")
	self.mouseCaptured=true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")): 
		self.mouseCaptured=!mouseCaptured
	pass

func _input(event):
	if event is InputEventMouseMotion:
		if(Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED): 
			var d = event.relative
			y-=d.y*ySensitivity
			#m(y)
			if(y<-0.9): y=-0.9
			if(y>0.9): y=0.9
			var b = Basis(Vector3(1,0,0),y)
			transform.basis = b
#	if event is InputEventAction:
#		event.action
#		if event.pressed && event.action=="ui_cancel":
#			self.mouseCaptured=!mouseCaptured
#		if event.pressed && event.action=="ui_up":
#			m("up")

func setCameraMode(var value):
	if(value): Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#m("SetCameraMode:"+String(value))
	mouseCaptured=value
func getCameraMode():
	return mouseCaptured
	
	
