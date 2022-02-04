extends Node

const Firefly = preload("res://scenes/firefly.tscn")
@onready var lantern = $Lantern as Lantern

@export var nb := 100
const MAX_FIREFLIES = 200
const MIN_FIREFLIES = 5
var fireflies := []

################################################################################

func _ready():
	# création des lucioles
	for i in range(nb):
		var firefly = Firefly.instantiate()
		add_child(firefly)
		fireflies.append(firefly)

func _process(delta):
	# bruitage
	var catched = fireflies.filter(func(x): return x.is_jittery).size()
	if catched > 0 and !lantern.sound.playing:
		lantern.fade_in()
	elif catched == 0 and lantern.sound.playing:
		lantern.fade_out()

func _on_lantern_area_entered(firefly : Firefly):
	if lantern.is_lighted:
		firefly.is_jittery = true
		firefly.target_obj = lantern
		firefly.find_new_target()

func _on_lantern_area_exited(firefly : Firefly):
	firefly.is_jittery = false
	firefly.target_obj = null
	firefly.find_new_target()
