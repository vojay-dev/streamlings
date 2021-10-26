class_name Walk
extends State

const position_history_size = 5

var walk_speed = 10
var position_history = []

func get_name():
	return "Walk"

func enter():
	streamling.play("walk")
	streamling.velocity.x = walk_speed * streamling.direction
	position_history.append(streamling.position.x)

func _get_movement():
	return abs(abs(position_history[0]) - abs(position_history[position_history.size() - 1]))

func physics_process(_delta):
	position_history.append(streamling.position.x)
	if position_history.size() > position_history_size:
		position_history.remove(0)
	
	if streamling.is_on_floor():
		if _get_movement() <= 0.01:
			_turn_around()

		streamling.velocity.x = walk_speed * streamling.direction
	else:
		state_machine.transition_to("Air")

func _turn_around():
	streamling.scale.x *= -1
	streamling.get_node("Labels").rect_scale.x *= -1

	streamling.direction *= -1
