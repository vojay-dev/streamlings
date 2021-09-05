class_name Out
extends State

func get_name():
	return "Out"

func enter():
	streamling.velocity.x = 0
	streamling.alive = false
	streamling.play_out()
