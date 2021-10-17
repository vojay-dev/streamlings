class_name Walk
extends State

var walk_speed = 10

func get_name():
	return "Walk"

func enter():
	streamling.play("walk")
	streamling.velocity.x = walk_speed * streamling.direction

func physics_process(_delta):
	if streamling.is_on_floor():
		if streamling.velocity.x == 0:
			_turn_around()

		streamling.velocity.x = walk_speed * streamling.direction
	else:
		state_machine.transition_to("Air")

func _turn_around():
	streamling.scale.x *= -1
	streamling.get_node("Labels").rect_scale.x *= -1

	streamling.direction *= -1
