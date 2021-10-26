class_name Build
extends State

var last_build

func get_name():
	return "Build"

func enter():
	last_build = OS.get_unix_time()
	streamling.velocity.x = 0
	streamling.play("build")

func physics_process(_delta):
	streamling.velocity.x = 0
	var now = OS.get_unix_time()
	var diff = now - last_build
	
	if diff >= 1:
		_build()
		last_build = now

func _build():
	if Global.active_level.stones <= 0:
		state_machine.transition_to("Walk")
		return
		
	var positions = []
	var streamling_position = streamling.position

	for i in range(1, 7):
		positions.append(Vector2(streamling_position.x + i * streamling.direction, streamling.position.y + 3))
		positions.append(Vector2(streamling_position.x + i * streamling.direction, streamling.position.y + 4))

	streamling.game.draw_pixels(positions, 255, 255, 255)
	streamling.game.update_collision_shape()
	
	streamling.position.x += 4 * streamling.direction
	streamling.position.y -= 1
	
	Global.active_level.stones -= 1

func exit():
	pass
