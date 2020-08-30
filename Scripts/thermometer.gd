extends Node2D

const Window = preload("res://Scripts/Window.gd")
const Door  = preload("res://Scripts/Door.gd")

export(NodePath) var thermometer_path
export(NodePath) var outdoor_ind_path
export(NodePath) var indoor_ind_path
export(Array,NodePath) var temp_up_arrows_paths
export(Array,NodePath) var temp_down_arrows_paths

var temp_in:float=40
var temp_out:float=40
var AC_temp:float=40
var AC_on=false
var windows_open:int=0
var front_door_open:int=0
var thermometer:CanvasItem
var outdoor_indicator:Sprite
var indoor_indicator:Sprite
var temp_up_arrows=[]
var temp_down_arrows=[]
var ac_sound:AudioStreamPlayer3D

var windows=[]
var front_door:Door

var temp_change:float=0.0

func _ready():
	var timekeeper = get_tree().get_root().find_node("TimeKeeper",true,false)
	ac_sound = get_tree().get_root().find_node("AC_Sound",true,false)
	timekeeper.connect("updated_time", self, "set_temp")
	thermometer=get_node(thermometer_path)
	for n in temp_up_arrows_paths: 
		temp_up_arrows.append(get_node(n))
	for n in temp_down_arrows_paths: 
		temp_down_arrows.append(get_node(n))
	outdoor_indicator=get_node(outdoor_ind_path)
	indoor_indicator=get_node(indoor_ind_path)
	
	temp_in=AC_temp
	#temp_in=temp_out
	outdoor_indicator.transform.origin.y=(temp_out/100)*-47
	indoor_indicator.transform.origin.y=(AC_temp/100)*-47
	var t = thermometer as Control
	t.margin_top=(temp_in/100)*-47
	
	var window_container = get_tree().get_root().find_node("Windows",true,false)
	var door_container = get_tree().get_root().find_node("Doors",true,false)
	front_door=door_container.get_node("front_door")
	windows=window_container.get_children()


func _process(delta):
	if Input.get_mouse_mode()!=Input.MOUSE_MODE_CAPTURED: return
	var last_in=temp_in
	temp_in=lerp(temp_in,temp_out,0.1*(temp_stabilize_mult()/13.0)*delta)
	if(temp_in>AC_temp): 
		AC_on=true
		ac_sound.playing=true
		temp_in=lerp(temp_in, AC_temp, 0.1*(1-(temp_stabilize_mult()/13.0))*delta)
	else: 
		ac_sound.playing=false
		AC_on=false
	var t = thermometer as Control
	t.margin_top=(temp_in/100)*-47
	temp_change=temp_in-last_in
	set_temp_change_arrows(temp_change)
	outdoor_indicator.transform.origin.y=(temp_out/100)*-47


func temp_stabilize_mult():
	windows_open=0
	for w in windows: 
		if w.is_open: 
			windows_open+=1
	if front_door.is_open: 
		front_door_open=true
	return windows_open+(front_door_open*2)

func set_temp(var time:float):
#	time+=86400/3
#	temp_out= (abs(fmod((time/86400*2),2)-1)*75)+25
	
	temp_out= sin((fmod(time+3600*16.5,86400)/86400)*2*PI)*75/2+55

func set_temp_change_arrows(var change):
	for n in temp_up_arrows: n.set("visible",false)
	for n in temp_down_arrows: n.set("visible",false)
	if change>0.001: temp_up_arrows[0].set("visible",true)
	if change>0.015: temp_up_arrows[1].set("visible",true)
	if change>0.030: temp_up_arrows[2].set("visible",true)
	if change<0.001:  temp_down_arrows[0].set("visible",true)
	if change<-0.015:  temp_down_arrows[1].set("visible",true)
	if change<-0.030:  temp_down_arrows[2].set("visible",true)
	
	pass
