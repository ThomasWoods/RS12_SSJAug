extends Control

var was_paused=false


func _ready():
	pause_mode=Node.PAUSE_MODE_PROCESS


func _process(delta):
	if Input.get_mouse_mode()==Input.MOUSE_MODE_VISIBLE and !was_paused: 
		_on_pause()
	if Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED and was_paused: 
		_on_unpause()

func _on_pause():
	self.show()
	was_paused=true
	pass
func _on_unpause():
	self.hide()
	was_paused=false
