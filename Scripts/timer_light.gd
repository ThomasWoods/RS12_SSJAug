extends SpotLight

export(int) var start_time=32400
export(int) var end_time=68400
export(bool) var invert=true

# Called when the node enters the scene tree for the first time.
func _ready():
	var timekeeper = get_tree().get_root().find_node("TimeKeeper",true,false)
	timekeeper.connect("updated_time", self, "set_state")

func set_state(var time):
	var t=fmod(time,86400)
	if t>start_time and t<end_time: 
		if invert: self.hide()
		else: self.show()
	else: 
		if invert: self.show()
		else: self.hide()
 
