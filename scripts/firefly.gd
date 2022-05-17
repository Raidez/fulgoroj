extends KinematicBody2D

# position
onready var SIZE = get_viewport_rect().size as Vector2
onready var hitbox := $CollisionShape2D
const padding = 10

# couleur
var tween
const BRIGHT_COLOR = Color8(173, 255, 0)
const DARKER_COLOR = Color8(26, 36, 7)
var color = BRIGHT_COLOR
var countdown = rand_range(1, 5)
var timer = rand_range(0, countdown)

# mouvement
var initial_speed = rand_range(10, 50) as int
var speed = initial_speed
var super_speed = 100
var radius setget set_radius
func set_radius(value):
	radius = value
	hitbox.shape.radius = value
var target = Vector2()
var target_obj
var is_jittery = false

################################################################################

func random_position(x_min, x_max, y_min, y_max):
	return Vector2(
		rand_range(x_min, x_max) as int,
		rand_range(y_min, y_max) as int
	)

## trouve une nouvelle cible pour la luciole
func find_new_target():
	if target_obj:
		target = Vector2(
			rand_range(target_obj.position.x - target_obj.radius / 2, target_obj.position.x + target_obj.radius / 2) as int,
			rand_range(target_obj.position.y - target_obj.radius / 2, target_obj.position.y + target_obj.radius / 2) as int
		)
	else:
		target = random_position(padding, SIZE.x - padding, padding, SIZE.y - padding)

func is_target_reached():
	return position.distance_to(target) < radius

################################################################################

func _ready():
	# définit la position de la luciole
	position = random_position(padding, SIZE.x - padding, padding, SIZE.y - padding)
	
	# définit la position de la cible
	find_new_target()
	
	# taille de la luciole
	radius = rand_range(4, 7) as int
	
	# animation
	tween = self.create_tween().set_loops()
	tween.tween_property(self, "color", DARKER_COLOR, countdown)
	tween.tween_property(self, "color", BRIGHT_COLOR, 0.1)
	tween.custom_step(timer)

func _process(delta):
	# état de la luciole
	if is_jittery:
		speed = super_speed
		color = BRIGHT_COLOR
	else:
		speed = initial_speed
		if tween and not tween.is_running(): tween.play()
	
	# déplacement de la luciole
	position = position.move_toward(target, speed * delta)
	
	# si la cible est atteinte, on réassigne une nouvelle cible avec une nouvelle vitesse
	if is_target_reached():
		find_new_target()
		initial_speed = rand_range(10, 50) as int
	
	update()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
