extends Node

const PlayerBody = preload("res://Scripts/PlayerBody.gd")
const PlayerCamera = preload("res://Scripts/PlayerCamera.gd")
const Event = preload("res://Scripts/Event.gd")
const UI = preload("res://Scripts/UI.gd")

var player_body:PlayerBody
var player_cam:PlayerCamera
var ui:UI
func m(var s): ui.set_text(s)

var in_event:bool = false
var last_event:Event = null

signal start_event
signal end_event

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player_body=$PlayerBody
	player_cam=player_body.get_node("Camera")
	ui = get_tree().get_root().find_node("UI",true,false)
	player_cam.connect("reset_camera_complete", player_body, "clear_camera_lock")


func _process(delta):
	if in_event: 
		last_event.elapsed_time+=delta
		if (Input.is_action_just_pressed("ui_accept") or 
				(last_event.timer>0 and last_event.elapsed_time>last_event.timer)):
			last_event.elapsed_time=0
			process_event(last_event)


func run_event(var event:Event):
	if in_event:
		if last_event==event: return
		else: last_event.abort_event()
	in_event=true
	last_event=event
	if event.lock_player:
		player_body.can_move=false
		player_body.camera_lock=false
		player_cam.free_look=false
	ui.text_continue.visible=event.timer==0
	process_event(last_event)

func process_event(var event:Event):
	var text=event.get_next_page()
	if text==null: 
		end_event()
	else: 
		player_cam.target = event.get_focus_target()
		m(text)
		event.finish_page()

func end_event():
	in_event=false
	if last_event.changed_camera(): 
		player_cam.reset_camera()
	else:
		player_cam.free_look=true
	ui.text_continue.visible=false
	m("")
	last_event.finish_event()
