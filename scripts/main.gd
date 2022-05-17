extends Node

const Firefly = preload("res://scenes/Firefly.tscn")
onready var lantern = $Lantern
onready var fireflies_parent = $Fireflies

# gestion des lucioles
export var nb = 100
const MAX_FIREFLIES = 200
const MIN_FIREFLIES = 5
var fireflies = []

################################################################################

func get_jittery_fireflies():
	var founds = []
	for f in fireflies:
		if f.is_jittery:
			founds.append(f)
	return founds

################################################################################

func _ready():
	# création des lucioles
	for i in range(nb):
		var firefly = Firefly.instance()
		fireflies_parent.add_child(firefly)
		fireflies.append(firefly)

func _process(delta):
	# bruitage
	var catched = get_jittery_fireflies().size()
	if catched > 0 and !lantern.sound.playing:
		lantern.fade_in()
	elif catched == 0 and lantern.sound.playing:
		lantern.fade_out()

################################################################################

func _on_Lantern_body_entered(body):
	body.is_jittery = true
	body.target_obj = lantern
	body.find_new_target()

func _on_Lantern_body_exited(body):
	body.is_jittery = false
	body.target_obj = null
	body.find_new_target()
