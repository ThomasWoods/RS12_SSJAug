extends Spatial

export(Array, NodePath) var targets
export(NodePath) var first_target
export(NodePath) var home
var target:Spatial

var speed=3


func _ready():
	randomize()
	pass

func start_haunt():
	yield(get_tree().create_timer(1.0), "timeout")
	target=get_node(first_target)
	move_towards_target()
	pass

func end_hunt():
	var tween:Tween=$Tween
	tween.stop_all()
	target=get_node(first_target)
	move_towards_target()

func on_reach_target():
	if target.has_method("use"):
		target.call("use")
	var r = randi()%targets.size()
	target=get_node(targets[r])
	move_towards_target()
	pass

func move_towards_target():
	var tween=$Tween
	tween.interpolate_property(self, "transform:origin",
		transform.origin, target.global_transform.origin, speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.connect("tween_all_completed", self, "on_reach_target")
	pass

#func _process(delta):
#	var target_global
#	if(target!=null):
#		transform.origin=transform.origin.move_toward(target.global_transform.origin, speed*delta)
#	pass


func _on_TimeKeeper_sun_down():
	end_hunt()
