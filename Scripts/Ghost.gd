extends Spatial

export(Array, NodePath) var targets
export(NodePath) var first_target
export(NodePath) var home
var target:Spatial
var haunting=false

var speed=3.75
var speed_variance=0.5

var tween:Tween


func _ready():
	randomize()
	tween=$Tween
	tween.connect("tween_all_completed", self, "on_reach_target")
	target=get_node(first_target)

func start_haunt():
	haunting=true
	on_reach_target(7)

func end_hunt():
	haunting=false
	tween.stop_all()
	target=get_node(home)
	move_towards_target()

func on_reach_target(var i:int=-1):
	if  haunting==false: 
		return
	if target.has_method("use"):
		target.call("use")
	if i==-1 or i<0 or i>targets.size(): 
		i = randi()%targets.size()
	target=get_node(targets[i])
	move_towards_target()

func move_towards_target():
	var distance = abs(transform.origin.distance_to(target.global_transform.origin))
	var rand_speed=speed*(randf()*speed_variance-speed_variance/2)
	tween.interpolate_property(self, "transform:origin",
		transform.origin, target.global_transform.origin, (distance+0.15)/speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_TimeKeeper_sun_down():
	end_hunt()
