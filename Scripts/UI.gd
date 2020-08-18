extends Control

export(NodePath) var text_path
export(NodePath) var text_cont_path
export(NodePath) var time_path

var textLabel:RichTextLabel
var text_continue:TextureRect
var clockLabel:RichTextLabel
var camera_lock_icon:TextureRect
var textMsg:String = "" setget set_text, get_text
var clockMsg:String = "" setget set_clock, get_clock

func set_text(var value):
	textMsg=String(value)
	textLabel.bbcode_text=textMsg
func get_text():
	return textMsg

func set_clock(var value):
	clockMsg="[center]"+String(value)+"[/center]"
	clockLabel.bbcode_text=clockMsg
func get_clock():
	return clockMsg

# Called when the node enters the scene tree for the first time.
func _ready():
	textLabel = get_node(text_path)
	text_continue = get_node(text_cont_path)
	text_continue.visible=false
	clockLabel = get_node(time_path)
	camera_lock_icon=$CameraLock

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func show_camera_icon():camera_lock_icon.visible=true;
func hide_camera_icon():camera_lock_icon.visible=false;
