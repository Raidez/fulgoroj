extends Area2D

class_name Firefly

# position
@onready var SIZE = get_viewport_rect().size as Vector2
@onready var body := $Body as CollisionShape2D
const padding = 10

# couleur
@onready var tween := get_tree().create_tween().set_loops()
const BRIGHT_COLOR = Color8(173, 255, 0)
const DARKER_COLOR = Color8(26, 36, 7)
var color := BRIGHT_COLOR
var countdown := randf_range(1, 5)
var timer := randf_range(0, countdown)

# mouvement
var initial_speed := randi_range(10, 50)
var speed := initial_speed
var super_speed := 100
var radius : int :
	set(r):
		radius = r
		(body.shape as CircleShape2D).radius = r
var target = Vector2()
var target_obj : Node
var is_jittery := false

################################################################################

func random_position(x_min : int, x_max : int, y_min : int, y_max : int) -> Vector2:
	return Vector2(
		randi_range(x_min, x_max),
		randi_range(y_min, y_max)
	)

## trouve une nouvelle cible pour la luciole
func find_new_target() -> void:
	if target_obj:
		target = Vector2(
			randi_range(target_obj.position.x - target_obj.radius / 2, target_obj.position.x + target_obj.radius / 2),
			randi_range(target_obj.position.y - target_obj.radius / 2, target_obj.position.y + target_obj.radius / 2)
		)
	else:
		target = random_position(padding, SIZE.x - padding, padding, SIZE.y - padding)

func is_target_reached() -> bool:
	return position.distance_to(target) < radius

################################################################################

func _ready():
	# définit la position de la luciole
	position = random_position(padding, SIZE.x - padding, padding, SIZE.y - padding)
	
	# définit la position de la cible
	find_new_target()
	
	# taille de la luciole
	radius = randi_range(4, 7)
	
	# animation
	tween.tween_property(self, "color", DARKER_COLOR, countdown)
	tween.tween_property(self, "color", BRIGHT_COLOR, 0)
	tween.custom_step(timer)

func _process(delta):
	# état de la luciole
	if is_jittery:
		speed = super_speed
		color = BRIGHT_COLOR
	else:
		speed = initial_speed
		tween.play()
	
	# déplacement de la luciole
	position = position.move_toward(target, speed * delta)
	
	# si la cible est atteinte, on réassigne une nouvelle cible avec une nouvelle vitesse
	if is_target_reached():
		find_new_target()
		initial_speed = randi_range(10, 50)
	
	update()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
