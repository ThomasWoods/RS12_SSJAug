extends Spatial

const UI = preload("res://Scripts/UI.gd")

export(NodePath) var ui_path
export(NodePath) var sun_path
export(Environment) var e:Environment

var ui:UI
var sun:Spatial

var paused:bool = true
var time:float = 0
var time_mult = 86400/(60*5)
var show_seconds = false

signal sun_rise
var sun_rise_sent=false
var sun_rise=6
signal sun_down
var sun_down_sent=false
var sun_set=21

signal updated_time(time)


func _ready():
	ui = get_node(ui_path)
	set_time(6,0)
	sun=get_node(sun_path)
	update_world()


func _process(delta):
	if Input.get_mouse_mode()!=Input.MOUSE_MODE_CAPTURED: return
	if paused: return
	time+=delta*time_mult
	emit_signal("updated_time", time)
	update_world()

func update_world():
	sun.rotation_degrees = Vector3(
		sun.rotation_degrees.x,
		sun.rotation_degrees.y,
		time_to_lat(time))
	e.set_ambient_light_sky_contribution(time_to_brightness(time))
	e.set_bg_energy(time_to_brightness(time))
	ui.set_clock(time_string(time))
	var day_time=fmod(time,86400)
	if !sun_rise_sent and day_time>hour_min_to_sec(sun_rise,0) and day_time<hour_min_to_sec(12,0):
		emit_signal("sun_rise")
		sun_rise_sent=true
		sun_down_sent=false
	if !sun_down_sent and fmod(time,86400)>hour_min_to_sec(sun_set,0):
		emit_signal("sun_down")
		sun_rise_sent=false
		sun_down_sent=true

func time_string(var f:float):
	var s:String=""
	var hours:int = int(f/3600)%24
	var minutes:int  = int(fmod(time,3600)/60)
	var seconds:int = int(fmod(f,60))
	var hours_string=String(hours) if hours>=10 else "0"+String(hours)
	var minutes_string=String(minutes) if minutes>=10 else "0"+String(minutes)
	var seconds_string=String(seconds) if seconds>=10 else "0"+String(seconds)
	
	s=hours_string+":"+minutes_string
	if show_seconds: s+=":"+seconds_string
	return s

func hour_min_to_sec(var hours:int, var minutes:int):
	return (hours*3600)+(minutes*60)
	
func set_time(var hours:int, var minutes:int):
	time=hour_min_to_sec(hours, minutes)
	
func time_to_lat(var t:float):
	return fmod((t/86400)*360,360)

func time_to_brightness(var t:float):
#	t+=86400/2
#	return (abs(fmod((t/86400*2),2)-1)*0.5)+0.8
	return (sin((fmod(time+3600*17.5,86400)/86400)*2*PI)+1)/2

func unpause():
	paused=false
