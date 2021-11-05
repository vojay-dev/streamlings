class_name Block
extends State

func get_name():
	return "Block"

func enter():
	streamling.activate_collision()
	streamling.play("block")
	streamling.velocity.x = 0
	streamling.infinite_inertia = false

func physics_process(_delta):
	streamling.velocity.x = 0
	
	if not streamling.down_collision():
		state_machine.transition_to("Air")

func exit():
	streamling.deactivate_collision()
	streamling.infinite_inertia = true
