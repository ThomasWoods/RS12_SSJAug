extends Area

const UI = preload("res://Scripts/UI.gd")
var ui:UI
func m(var s): ui.set_text(s)

export(Array, String) var event_text = ["page one", "page two"]
export(Array, NodePath) var focus_targets = [null,null]
export(Array) var event_calls = []
export(float) var timer=0
var elapsed_time:float = 0
var fired:bool = false
export var repeating:bool = false
export var lock_player:bool = true

var page:int = 0

signal event_reset
signal event_completed

func _ready():
	ui = get_tree().get_root().find_node("UI",true,false)
	connect("body_entered", self, "on_player_entered")

func on_player_entered(var body:Node):
	if body and body.get_owner() and body.get_owner().has_method("run_event"):
		body.get_owner().call("run_event", self)

func get_next_page():
	if page<event_text.size():
		var text = event_text[page]
		run_event_calls()
		return text
	else:
		return null

func run_event_calls():
	if event_calls.size()>page and event_calls[page]!=null:
		var dict=event_calls[page] as Dictionary
		for key in dict:
			var node=get_node(key)
			if node!=null and node.has_method(dict[key]):
				node.call(dict[key])
				pass
	pass

func get_focus_target():
	if page<focus_targets.size():
		var focus_target = focus_targets[page]
		if focus_target!=null: 
			return get_node(focus_target)
	return null

func finish_page():
	page+=1
	
func abort_event():
		page=0
		emit_signal("event_reset")
		
func finish_event():
	if repeating: 
		page=0
		emit_signal("event_reset")
	else:
		self.collision_layer=0
		self.collision_mask=0
		emit_signal("event_completed")

func changed_camera():
	return focus_targets.size()>0
