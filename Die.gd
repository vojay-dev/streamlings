class_name Die
extends State

func get_name():
	return "Die"

func enter():
	streamling.velocity.x = 0
	streamling.alive = false
	streamling.play("hit_ground")
