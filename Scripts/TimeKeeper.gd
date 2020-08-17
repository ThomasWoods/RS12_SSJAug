extends Node

const UI = preload("res://Scripts/UI.gd")

export(NodePath) var ui_path
export(NodePath) var sun_path

var ui:UI
var sun

var time:float =0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	ui = get_node(ui_path)
	sun = get_node(sun_path)
	
	#ui.set_text("Hello")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ui.set_clock("12:34")
	pass
