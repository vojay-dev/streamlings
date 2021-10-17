class_name Air
extends State

var air_speed = 1

var max_fall_speed = 0
var max_fall_speed_survive = 120
var max_fall_speed_umbrella = 40

func get_name():
	return "Air"

func enter():
	streamling.play("air")

func physics_process(_delta):
	if streamling.umbrella_activated:
		streamling.play("umbrella")
		streamling.velocity.y = min(streamling.velocity.y, max_fall_speed_umbrella)
	
	streamling.velocity.x = air_speed * streamling.direction
	max_fall_speed = max(max_fall_speed, streamling.velocity.y)
	
	if streamling.is_on_floor():
		if max_fall_speed > max_fall_speed_survive:
			streamling.kill()
		else:
			state_machine.transition_to("Walk")
