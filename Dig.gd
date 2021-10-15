class_name Dig
extends State

var timer
var last_dig

func get_name():
	return "Dig"

func enter():
	last_dig = OS.get_unix_time()
	
	streamling.get_node("Animations").offset.y += 2
	streamling.play("dig")
	streamling.velocity.x = 0

	timer = Timer.new()
	add_child(timer)

	timer.wait_time = 1
	timer.one_shot = false

	timer.connect("timeout", self, "_dig")
	#timer.start()

func physics_process(_delta):
	streamling.velocity.x = 0
	var now = OS.get_unix_time()
	var diff = now - last_dig
	
	if diff >= 1:
		_dig()
		last_dig = now
	elif not streamling.down_collision():
		state_machine.transition_to("Air")

func _dig():
	var positions = []
	var streamling_position = streamling.position

	for i in range(-4, 5):
		for j in range(-1, 5):
			positions.append(Vector2(streamling_position.x + i, streamling.position.y + 4 + j))

	streamling.game.delete_pixels(positions)
	streamling.game.update_collision_shape()
	streamling.emit_dig_particles()

func exit():
	timer.stop()
	timer.queue_free()
	streamling.get_node("Animations").offset.y -= 2
