extends Control

@onready var timer = $Timer as Timer
@onready var animation = $FadingMessage as AnimationPlayer
var was_clicked := false
var is_visible := false

func _input(event):
	# le message disparaît après une action du joueur
	if not was_clicked && (event.is_action("light_lantern") \
		or event.is_action("increase_lantern") \
		or event.is_action("decrease_lantern")):
		was_clicked = true
		timer.stop()
		
		if is_visible:
			animation.stop(false)
			animation.playback_speed = 3.5
			animation.play_backwards("fade_in")

func _on_timer_timeout():
	animation.play("fade_in")
	is_visible = true
