extends Node

const PlayerBody = preload("res://Scripts/PlayerBody.gd")
const PlayerCamera = preload("res://Scripts/PlayerCamera.gd")
const Event = preload("res://Scripts/Event.gd")
const UI = preload("res://Scripts/UI.gd")

var player_body:PlayerBody
var player_cam:PlayerCamera
var ui:UI
var reticle:TextureRect
func m(var s): ui.set_text(s)
var active_camera:Camera

var reach_cast:RayCast
var holding_item
var item_held
var disabled_colliders = []

var in_event:bool = false
var last_event:Event = null

export(Resource) var def_reticle
export(Resource) var hand_reticle

signal start_event
signal end_event


func _ready():
	player_body=$PlayerBody
	player_cam=player_body.get_node("Camera")
	reach_cast=player_cam.get_node("Reach")
	ui = get_tree().get_root().find_node("UI",true,false)
	reticle=ui.get_node("Reticle")
	player_cam.connect("reset_camera_complete", player_body, "clear_camera_lock")
	player_cam.connect("lock_camera", ui, "show_camera_icon")
	player_cam.connect("reset_camera_complete", ui, "hide_camera_icon")
	active_camera=player_cam

func _process(delta):
	if Input.get_mouse_mode()!=Input.MOUSE_MODE_CAPTURED: return
	if Input.is_action_just_pressed("flashlight"):
		var f = player_cam.get_node("flashlight") as SpotLight
		f.visible=!f.visible
	if Input.is_action_just_pressed("ui_home"):
		switch_camera()
	reticle.set_texture(def_reticle)
	if in_event: 
		last_event.elapsed_time+=delta
		if (Input.is_action_just_pressed("ui_accept") or 
				(last_event.timer>0 and last_event.elapsed_time>last_event.timer)):
			last_event.elapsed_time=0
			process_event(last_event)
	elif holding_item and Input.is_action_just_pressed("ui_accept"):
		drop_item()
	elif not holding_item and reach_cast.is_colliding():
		var reach_obj:Node = reach_cast.get_collider()
		if reach_obj!=null:
			#m(reach_obj.name)
			#TODO: change pointer to hand here
			reticle.set_texture(hand_reticle)
			if (Input.is_action_just_pressed("ui_accept")):
				if(reach_obj.has_method("interact")): 
					reach_obj.call("interact")
				else:
					pick_up_item(reach_obj)
	elif not holding_item and item_held!=null and Input.is_action_just_pressed("ui_end"):
		pick_up_item(item_held)

func find_and_run_event(var event_name:String):
	var events = get_tree().get_root().find_node("Events",true,false)
	var event=events.get_node(event_name).get_node("Area") as Event
	if(event!=null):
		run_event(event)
	pass

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
		player_cam.reset_camera_end()
	ui.text_continue.visible=false
	m("")
	last_event.finish_event()


func pick_up_item(var item:Node):
	holding_item=true
	item_held=item
	disable_colliders(item)
	decouple_obj(item)
	couple_obj(item,player_cam)
	m("Picked up "+item.get("name"))
	pass
	
func drop_item():
	decouple_obj(item_held)
	get_tree().get_root().add_child(item_held)
	reenable_colliders()
	holding_item=false
	m("")


func decouple_obj(var item:Spatial):
	if item==null or item.get_parent()==null: return
	var parent:Spatial = item.get_parent() as Spatial
	var o:Vector3 = item.get_global_transform().origin
	var b:Basis = item.get_global_transform().basis
	item.get_parent().remove_child(item)
	if parent==null: return
	item.transform.origin = o
	item.transform.basis = b
	var rigid = item as RigidBody
	var par_rigid = parent as RigidBody
	if rigid: 
		if par_rigid:
			rigid.angular_velocity=par_rigid.angular_velocity
			rigid.linear_velocity=par_rigid.linear_velocity
		else:
			rigid.angular_velocity=Vector3.ZERO
			rigid.linear_velocity=Vector3.ZERO

func couple_obj(var item:Spatial, var new_parent:Spatial):
	if item==null or new_parent == null: return
	new_parent.add_child(item)
	item.transform.origin=Vector3(0,0,-0.75)
	item.transform.basis=Basis(Vector3(0,1,0),0)


func disable_colliders(var node:RigidBody):
	node.set_mode(RigidBody.MODE_KINEMATIC)
	for child in node.get_children():
		if child as CollisionShape:
			var c = child as CollisionShape
			disabled_colliders.append(c)
			c.disabled=true

func reenable_colliders():
	item_held.set_mode(RigidBody.MODE_RIGID)
	for child in disabled_colliders:
		if child as CollisionShape:
			var c = child as CollisionShape
			c.disabled=false
	disabled_colliders=[]


func switch_camera():
	if active_camera==player_body.get_node("Camera"): 
		active_camera=player_body.get_node("Camera2")
	else:
		active_camera=player_body.get_node("Camera")
	active_camera.make_current()
