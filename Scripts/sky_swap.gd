extends Spatial

export(int) var start_time=18000
export(int) var end_time=79200
export(bool) var invert=false
export(Resource) var day_sky
export(Resource) var night_sky
export(Environment) var environ:Environment

var is_day = true
var sky:PanoramaSky

# Called when the node enters the scene tree for the first time.
func _ready():
	var timekeeper = get_tree().get_root().find_node("TimeKeeper",true,false)
	timekeeper.connect("updated_time", self, "set_state")
	sky=environ.get_sky()

func set_state(var time):
	pass
#	var t=fmod(time,86400)
#	if t>start_time and t<end_time: 
#		if !is_day:
#			is_day=true
#			if invert: sky.set_panorama(night_sky)
#			else: sky.set_panorama(day_sky)
#	else: 
#		if is_day:
#			is_day=false
#			if invert: sky.set_panorama(day_sky)
#			else: sky.set_panorama(night_sky)
 
