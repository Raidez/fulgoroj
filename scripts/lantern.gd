extends Area2D

class_name Lantern

@onready var sound = $Sound as AudioStreamPlayer2D

const COLOR = Color8(236, 100, 75)
var is_lighted := false

# taille du cercle
@onready var timer = $Timer as Timer
@onready var hitbox = $Hitbox as CollisionShape2D
const MIN_RADIUS = 20
const MAX_RADIUS = 150
var radius : int :
	set(r):
		radius = r
		(hitbox.shape as CircleShape2D).radius = r
var is_growing := false

################################################################################

func fade_in():
	var tween := get_tree().create_tween()
	tween.tween_callback(func(): sound.play())
	tween.tween_property(sound, "volume_db", 0.0, 1.2)
	tween.play()

func fade_out():
	var tween := get_tree().create_tween()
	tween.tween_property(sound, "volume_db", -20.0, 0.8)
	tween.tween_callback(func(): sound.stop())
	tween.play()

################################################################################

func _ready():
	# taille de la lanterne
	radius = 50

func _process(delta):
	# la lanterne suit la souris
	position = get_viewport().get_mouse_position()
	
	# dés/active la lanterne
	monitoring = is_lighted
	
	update()

func _draw():
	if is_lighted:
		draw_circle(Vector2.ZERO, radius, COLOR)
	elif is_growing:
		draw_arc(Vector2.ZERO, radius, 0, TAU, 50, COLOR)

func _input(event):
	# allume la lanterne
	if event.is_action_pressed("light_lantern"):
		is_lighted = true
		timer.stop()
	if event.is_action_released("light_lantern"):
		is_lighted = false
	if event.is_action_pressed("increase_lantern"):
		is_growing = true
		timer.start()
	if event.is_action_pressed("decrease_lantern"):
		is_growing = true
		timer.start()
	
	# permet de changer la taille de la lanterne
	if event.is_action_released("increase_lantern"):
		radius += 5
		radius = min(radius, MAX_RADIUS)
		timer.start()
	if event.is_action_released("decrease_lantern"):
		radius -= 5
		radius = max(radius, MIN_RADIUS)
		timer.start()

func _on_timer_timeout():
	# lorsque le timer est fini, on éteint la lanterne
	is_growing = false
