extends Control

onready var timer = $Timer
onready var animation = $AnimationPlayer
var was_clicked = false
var is_visible = false

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
			animation.play_backwards("message_fadein")


func _on_Timer_timeout():
	animation.play("message_fadein")
	is_visible = true
