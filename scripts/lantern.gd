extends Area2D

onready var sound = $AudioStreamPlayer2D
const COLOR = Color8(236, 100, 75)
var is_lighted = false

# taille du cercle
onready var timer = $Timer
onready var hitbox = $CollisionShape2D
const MIN_RADIUS = 20
const MAX_RADIUS = 150
var is_growing = false
var radius setget set_radius
func set_radius(value):
	radius = value
	hitbox.shape.radius = value

################################################################################

func fade_in():
	var tween := get_tree().create_tween()
	tween.tween_callback(sound, "play")
	tween.tween_property(sound, "volume_db", 0.0, 1.2)
	tween.play()

func fade_out():
	var tween := get_tree().create_tween()
	tween.tween_property(sound, "volume_db", -80.0, 0.8)
	tween.tween_callback(sound, "stop")
	tween.play()

################################################################################

func _ready():
	# taille de la lanterne
	self.radius = 50

func _process(delta):
	# la lanterne suit la souris
	position = get_viewport().get_mouse_position()

	# allume la lanterne
	if Input.is_action_pressed("light_lantern"):
		is_lighted = true
		timer.stop()
	if Input.is_action_just_released("light_lantern"):
		is_lighted = false
	
	# dés/active la lanterne
	monitoring = is_lighted
	
	update()

func _draw():
	if is_lighted:
		draw_circle(Vector2.ZERO, radius, COLOR)
	elif is_growing:
		draw_arc(Vector2.ZERO, radius, 0, TAU, 50, COLOR)

func _input(event):
	# change la taille de la lanterne
	if event.is_action_pressed("increase_lantern"):
		is_growing = true
		timer.start()
	if event.is_action_pressed("decrease_lantern"):
		is_growing = true
		timer.start()
	
	if event.is_action_released("increase_lantern"):
		self.radius += 5
		self.radius = min(radius, MAX_RADIUS)
		timer.start()
	if event.is_action_released("decrease_lantern"):
		self.radius -= 5
		self.radius = max(radius, MIN_RADIUS)
		timer.start()

################################################################################

func _on_Timer_timeout():
	# lorsque le timer est fini, on éteint la lanterne
	is_growing = false
