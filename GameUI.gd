extends Control

signal reset_level
signal level_done

onready var game: Game = owner as Game

func update_user_list():
	$UserListHeader.text = "Active Streamlings %d" % [game.streamlings.size()]

	var text = ""

	for streamling in game.streamlings:
		text += "%s\n" % [streamling]

	$ScrollContainer/UserList.text = text

func update_streamlings_saved_label():
	if Global.active_level:
		$StreamlingSavedLabel.text = "Streamlings saved %d of %d" % [Global.streamlings_saved, Global.active_level.lemming_threshold]

func show_winning_screen():
	$UserListBackground.visible = false
	$UserListPanel.visible = false
	$ScrollContainer.visible = false
	$UserListHeader.visible = false
	$StreamlingsSavedBackground.visible = false
	$StreamlingsSavedPanel.visible = false
	$StreamlingSavedLabel.visible = false
	$EnableFullscreen.visible = false
	$DisableFullscreen.visible = false
	$ResetLevel.visible = false
	$BackToMenu.visible = false
	$Resources.visible = false
	$Timer.visible = false
	$Commands.visible = false

	$WinOverlay.visible = true
	$WinOverlay/Tween.interpolate_property($WinOverlay, "modulate", Color8(255, 255, 255, 0), Color8(255, 255, 255, 255), 2)
	$WinOverlay/Tween.start()

	$WinOverlay/WinningSound.play()

	$WinOverlay/LevelDoneTimer.start()

func flash(r, g, b, duration = .2, initial_alpha = 70):
	$Flash.visible = true
	$Flash/Tween.interpolate_property($Flash, "color", Color8(r, g, b, initial_alpha), Color8(r, g, b, 0), duration)
	$Flash/Tween.start()

func _on_Tween_tween_all_completed():
	$Flash.visible = false

func _ready():
	update_streamlings_saved_label()
	$Commands/Channel.text = Global.channel
	_on_OpenClose_pressed()

func _on_UserListUpdateTimer_timeout():
	update_user_list()

func _physics_process(_delta):
	update_streamlings_saved_label()
	update_timer_label()
	$EnableFullscreen.visible = !OS.window_fullscreen
	$DisableFullscreen.visible = OS.window_fullscreen and not OS.has_feature("web")

	if Global.active_level:
		$Resources/StoneLabel.text = str(Global.active_level.stones)
		$Resources/UmbrellaLabel.text = str(Global.active_level.umbrellas)

func _on_EnableFullscreen_pressed():
	Global.enable_fullscreen()

func _on_DisableFullscreen_pressed():
	Global.disable_fullscreen()

func _on_ResetLevel_pressed():
	emit_signal("reset_level")

func _on_BackToMenu_pressed():
	var _error = get_tree().change_scene("res://Menu.tscn")

	if Global.active_level:
		Global.reset()

func _on_LevelDoneTimer_timeout():
	emit_signal("level_done")

func start_timer():
	if $Timer/Timer.is_stopped():
		$Timer/Timer.start()

func stop_timer():
	$Timer/Timer.stop()

func get_time():
	return int($Timer/TimerLabel.text)

func update_timer_label():
	$Timer/TimerLabel.text = str(Global.level_time)

func _on_Timer_timeout():
	Global.level_time += 1

var commands_open = false

func _on_OpenClose_pressed():
	if not $Commands/Tween.is_active():
		var current_position = $Commands.rect_position
		$Commands/Tween.interpolate_property(
			$Commands,
			"rect_position",
			current_position,
			Vector2(current_position.x - 100 * (-1 if commands_open else 1), current_position.y),
			1.2,
			Tween.TRANS_BOUNCE,
			Tween.EASE_OUT
		)

		$Commands/Tween.interpolate_property(
			$Commands/OpenClose,
			"rect_rotation",
			0 if commands_open else 180,
			180 if commands_open else 0,
			.5,
			Tween.TRANS_LINEAR,
			Tween.EASE_OUT
		)

		$Commands/Tween.start()
		commands_open = not commands_open

