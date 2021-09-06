class_name Game
extends Node2D

var texture = ImageTexture.new()
var image = Image.new()
var bitMap = BitMap.new()

var streamling = preload("res://Streamling.tscn")
var streamlings = {}
var streamlings_saved = []

var show_state = false
var update_collision_shape = true

func _init_gift():
	var botname := "justinfan1928912891"
	var token := ""
	var initial_channel = "vojay"

	$Gift.connect_to_twitch()
	yield($Gift, "twitch_connected")

	$Gift.authenticate_oauth(botname, token)
	if(yield($Gift, "login_attempt") == false):
	  print("Invalid username or token.")
	  return
	$Gift.join_channel(initial_channel)

func _show_splash():
	$Splash.visible = true
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(
		$Splash,
		"color",
		Color8(23, 23, 23, 255),
		Color8(23, 23, 23, 0),
		1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)

	tween.connect("tween_all_completed", self, "_hide_splash")
	tween.start()

func _hide_splash():
	print("hiding")
	$Splash.queue_free()

func _ready():
	_show_splash()

	image = $Level/LevelSprite.texture.get_data()
	texture.create_from_image(image, 0)
	$Level/LevelSprite.texture = texture

	update_collision_shape()

	#_init_twitch()
	_init_gift()
	$GameUI.update_user_list()

func _init_twitch():
	$TwitchClient.channel_name = "vojay"
	$TwitchClient.irc_connect()
	$TwitchClient.start()

func _physics_process(delta):
	if Input.is_action_just_pressed("debug_menu"):
		$DebugOverlay.visible = !$DebugOverlay.visible

	OS.set_window_title("fps: %d" % Engine.get_frames_per_second())
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		image.lock()
		var mouse_pos = get_global_mouse_position()

		var rect_size = 10

		for i in range(rect_size/2):
			for j in range(rect_size/2):
				image.set_pixel(mouse_pos.x - i, mouse_pos.y - j, Color(0, 0, 0, 0))
				image.set_pixel(mouse_pos.x + i, mouse_pos.y + j, Color(0, 0, 0, 0))
				image.set_pixel(mouse_pos.x - i, mouse_pos.y + j, Color(0, 0, 0, 0))
				image.set_pixel(mouse_pos.x + i, mouse_pos.y - j, Color(0, 0, 0, 0))

		image.unlock()
		update_collision_shape()

	if update_collision_shape:
		_update_collision_shape()
		update_collision_shape = false

func delete_pixels(pixel_positions):
	for pixel_position in pixel_positions:
		image.lock()
		image.set_pixel(pixel_position.x, pixel_position.y, Color(0, 0, 0, 0))
		image.unlock()

func update_collision_shape():
	update_collision_shape = true

func _update_collision_shape():
	texture.create_from_image(image, 0)
	$Level/LevelSprite.texture = texture

	for node in get_tree().get_nodes_in_group("collision_polygons"):
		node.free()

	bitMap.create_from_image_alpha(image)

	var rect = Rect2(Vector2.ZERO, image.get_size())
	var polygons = bitMap.opaque_to_polygons(rect)

	for polygon in polygons:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = polygon
		collision_polygon.add_to_group("collision_polygons")

		$Level.add_child(collision_polygon)

func _on_TwitchClient_received_chat_message(user, message):
	pass

func _on_Streamling_die(streamling_name):
	streamlings.erase(streamling_name)

func _on_TwitchClient_received_command(user, command: String, args):
	command = command.to_lower()

	if command == "join":
		create_lemming(user)

	if user in streamlings:
		if command in ["schirm", "regenschirm", "umbrella"]:
			umbrella(user)

		if command in ["block", "blocken", "stehen", "stop", "stoppen", "halt", "halten"]:
			block(user)

		if command in ["walk", "laufen", "gehen", "go"]:
			walk(user)

		if command in ["dig", "dick", "buddeln", "graben", "mine", "creuser"]:
			dig(user)

		if command in ["kill", "suicide", "aufgeben", "platzen", "puff", "nooo", "harakiri"]:
			kill(user)

func umbrella(user):
	if user in streamlings:
		streamlings[user].activate_umbrella()

func block(user):
	if user in streamlings:
		streamlings[user].block()

func walk(user):
	if user in streamlings:
		streamlings[user].walk()

func dig(user):
	if user in streamlings:
		streamlings[user].dig()

func kill(user):
	if user in streamlings:
		streamlings[user].kill()

func out(user):
	if user in streamlings:
		streamlings[user].out()

func create_lemming(user):
	if not user in streamlings.keys():
		var streamling = self.streamling.instance()
		$Streamlings.add_child(streamling)
		streamlings[user] = streamling

		streamling.set_name(user, streamlings.size() % 2)
		streamling.position = $SpawnPosition.position
		streamling.game = self

		streamling.connect("die", self, "_on_Streamling_die")

func _on_Ground_body_entered(streamling):
	streamling.out()

func _on_Goal_streamling_reached_goal(streamling: Streamling):
	streamling.shrink()
	streamlings.erase(streamling.streamling_name)
	
	if not streamling.streamling_name in streamlings_saved:
		Global.streamlings_saved += 1
		$GameUI.update_streamlings_saved_label()
		
		if Global.streamlings_saved >= Global.streamlings_threshold:
			print("YAY GEWONNEN LEUDE")
			get_tree().reload_current_scene()
	
	streamlings_saved.append(streamling.streamling_name)

func _on_Gift_chat_message(sender_data, message):
	$Chat.text += message + "\n"
