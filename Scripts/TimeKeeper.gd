extends Node

const UI = preload("res://Scripts/UI.gd")

export(NodePath) var ui_path
export(NodePath) var sun_path

var ui:UI
var sun

var time:float =0
var time_mult=60
var show_seconds=false


func _ready():
	ui = get_node(ui_path)
	sun = get_node(sun_path)
	set_time(16,55)


func _process(delta):
	time+=delta*time_mult
	ui.set_clock(time_string(time))

func time_string(var f:float):
	var s:String=""
	var hours:int = int(f/3600)%24
	var minutes:int  = int(fmod(time,3600)/60)
	var seconds:int = fmod(f,60)
	var hours_string=String(hours) if hours>=10 else "0"+String(hours)
	var minutes_string=String(minutes) if minutes>=10 else "0"+String(minutes)
	var seconds_string=String(seconds) if seconds>=10 else "0"+String(seconds)
	
	s=hours_string+":"+minutes_string
	if show_seconds: s+=":"+seconds_string
	return s

func set_time(var hours:int, var minutes:int):
	time=(hours*3600)+(minutes*60)
