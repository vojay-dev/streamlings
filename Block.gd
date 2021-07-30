class_name Block
extends State

func get_name():
	return "Block"

func enter():
	streamling.activate_collision()
	streamling.play("block")
	streamling.velocity.x = 0

func exit():
	streamling.deactivate_collision()
