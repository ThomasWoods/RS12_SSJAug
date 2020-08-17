extends Node

const PlayerBody = preload("res://Scripts/PlayerBody.gd")
const PlayerCamera = preload("res://Scripts/PlayerCamera.gd")
const Event = preload("res://Scripts/Event.gd")
const UI = preload("res://Scripts/UI.gd")

var player_body:PlayerBody
var player_cam:PlayerCamera
var ui:UI
func m(var s): ui.set_text(s)

var reach_cast:RayCast
var holding_item
var item_held

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
	reach_cast=player_cam.get_node("Reach")
	ui = get_tree().get_root().find_node("UI",true,false)
	player_cam.connect("reset_camera_complete", player_body, "clear_camera_lock")
	Input.warp_mouse_position(OS.get_real_window_size()/2)
	

func _process(delta):
	if in_event: 
		last_event.elapsed_time+=delta
		if (Input.is_action_just_pressed("ui_accept") or 
				(last_event.timer>0 and last_event.elapsed_time>last_event.timer)):
			last_event.elapsed_time=0
			process_event(last_event)
	else:
		if holding_item and Input.is_action_just_pressed("ui_accept"):
			drop_item()
		elif(reach_cast.is_colliding()):
			var reach_obj:Node = reach_cast.get_collider()
			if reach_obj!=null:
				m(reach_obj.name)
				if (Input.is_action_just_pressed("ui_accept")):
					pick_up_item(reach_obj)

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


func pick_up_item(var item:Node):
	holding_item=true
	item_held=item
	decouple_obj(item)
	couple_obj(item,player_cam)
	pass
	
func drop_item():
	decouple_obj(item_held)
	get_tree().get_root().add_child(item_held)
	holding_item=false
	item_held=null


func decouple_obj(var item:Spatial):
	if item==null or item.get_parent()==null: return
	var parent:Spatial = item.get_parent() as Spatial
	var o:Vector3 = item.get_global_transform().origin
	var b:Basis = item.get_global_transform().basis
	item.get_parent().remove_child(item)
	if parent==null: return
	item.transform.origin = o
	item.transform.basis = b

func couple_obj(var item:Spatial, var new_parent:Spatial):
	if item==null or new_parent == null: return
	new_parent.add_child(item)
	item.transform.origin=Vector3(0,0,-2)
	item.transform.basis=Basis(Vector3(0,1,0),0)
