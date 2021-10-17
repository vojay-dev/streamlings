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
	randomize()
	var botname := "justinfan" + str(randi())
	var token := ""

	$Gift.connect_to_twitch()
	yield($Gift, "twitch_connected")

	$Gift.authenticate_oauth(botname, token)
	if(yield($Gift, "login_attempt") == false):
	  print("Invalid username or token.")
	  return
	$Gift.join_channel(Global.channel)

	$Gift.add_command("join", self, "create_lemming")

	_add_command(["schirm", "regenschirm", "umbrella"], "umbrella")
	_add_command(["block", "blocken", "stehen", "stop", "stoppen", "halt", "halten"], "block")
	_add_command(["walk", "laufen", "gehen", "go"], "walk")
	_add_command(["dig", "dick", "buddeln", "graben", "mine", "creuser"], "dig")
	_add_command(["kill", "suicide", "aufgeben", "platzen", "puff", "nooo", "harakiri"], "kill")
	_add_command(["build", "stairs", "treppe", "bauen", "stufen", "steine"], "build")

	$Gift.add_command("reset", self, "reset", 0, 0, Gift.PermissionFlag.STREAMER)

func _add_command(aliases, func_name):
	for alias in aliases:
		print("adding alias: %s for function %s" % [alias, func_name])
		$Gift.add_command(alias, self, func_name)

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
	_load_level()
	_init_gift()

	$GameUI.update_user_list()

func _physics_process(_delta):
	if Input.is_action_just_pressed("debug_menu"):
		$DebugOverlay.visible = !$DebugOverlay.visible

	OS.set_window_title("fps: %d" % Engine.get_frames_per_second())
	if Global.mouse_enabled and Input.is_mouse_button_pressed(BUTTON_LEFT):
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

func draw_pixels(pixel_positions, r, g, b):
	for pixel_position in pixel_positions:
		image.lock()
		image.set_pixel(pixel_position.x, pixel_position.y, Color8(r, g, b, 255))
		image.unlock()

func update_collision_shape():
	update_collision_shape = true

func _update_collision_shape():
	texture.create_from_image(image, 0)
	Global.active_level.get_node("LevelSprite").texture = texture

	for node in get_tree().get_nodes_in_group("collision_polygons"):
		node.free()

	bitMap.create_from_image_alpha(image)

	var rect = Rect2(Vector2.ZERO, image.get_size())
	var polygons = bitMap.opaque_to_polygons(rect, 1.5)

	for polygon in polygons:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = polygon
		collision_polygon.add_to_group("collision_polygons")

		Global.active_level.add_child(collision_polygon)

func _on_Streamling_die(streamling_name):
	streamlings.erase(streamling_name)

func umbrella(cmd_info : CommandInfo):
	var user = cmd_info.sender_data.user
	if user in streamlings:
		streamlings[user].activate_umbrella()

func block(cmd_info : CommandInfo):
	var user = cmd_info.sender_data.user
	if user in streamlings:
		streamlings[user].block()

func walk(cmd_info : CommandInfo):
	var user = cmd_info.sender_data.user
	if user in streamlings:
		streamlings[user].walk()

func dig(cmd_info : CommandInfo):
	var user = cmd_info.sender_data.user
	if user in streamlings:
		streamlings[user].dig()

func build(cmd_info : CommandInfo):
	var user = cmd_info.sender_data.user
	if user in streamlings:
		streamlings[user].build()

func kill(cmd_info : CommandInfo):
	var user = cmd_info.sender_data.user
	if user in streamlings:
		streamlings[user].kill()

func out(cmd_info : CommandInfo):
	var user = cmd_info.sender_data.user
	if user in streamlings:
		streamlings[user].out()

func create_lemming(cmd_info : CommandInfo):
	var user = cmd_info.sender_data.user

	if not user in streamlings.keys():
		var streamling = self.streamling.instance()
		$Streamlings.add_child(streamling)
		streamlings[user] = streamling

		streamling.set_name(user)
		streamling.position = Global.active_level.get_node("Spawn").get_spawn_position()
		streamling.game = self

		streamling.connect("die", self, "_on_Streamling_die")

func _on_Ground_body_entered(streamling):
	streamling.out()

func _on_Level_streamling_reached_goal(streamling: Streamling):
	streamling.shrink()
	streamlings.erase(streamling.streamling_name)

	if not streamling.streamling_name in streamlings_saved:
		Global.streamlings_saved += 1
		$GameUI.update_streamlings_saved_label()

		if Global.streamlings_saved >= Global.active_level.lemming_threshold:
			if Global.active_level:
				Global.active_level = null

			var _error = get_tree().change_scene("res://Menu.tscn")

	streamlings_saved.append(streamling.streamling_name)

func reset(_cmd_info : CommandInfo):
	_reset()

func _reset():
	_load_level()
	$GameUI.update_user_list()

	for user in streamlings:
		streamlings[user].queue_free()

	streamlings.clear()

	Global.streamlings_saved = 0

func _load_level():
	if Global.active_level:
		Global.active_level.queue_free()

	Global.active_level = Global.selected_level.instance()

	add_child(Global.active_level)
	move_child(Global.active_level, 1)

	image = Global.active_level.get_node("LevelSprite").texture.get_data()
	texture.create_from_image(image, 0)
	Global.active_level.get_node("LevelSprite").texture = texture

	update_collision_shape()
	Global.active_level.connect("streamling_reached_goal", self, "_on_Level_streamling_reached_goal")

func _on_GameUI_reset_level():
	_reset()
