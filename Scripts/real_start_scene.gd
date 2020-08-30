extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var go=false
var wait=true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if go:
		if wait: wait=!wait
		else: get_tree().change_scene("res://Scenes/StartScene.tscn")
	pass

func _input(event):
	if event is InputEventMouseButton:
		$RichTextLabel3.bbcode_text="[center][color=black]Loading..."
		go=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
