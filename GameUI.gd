extends Control

signal reset_level
signal level_done

onready var game: Game = owner as Game

func update_user_list():
	$UserListHeader.text = "Aktive Streamlinge (%d):" % [game.streamlings.size()]

	var text = ""

	for streamling in game.streamlings:
		text += "%s\n" % [streamling]

	$ScrollContainer/UserList.text = text

func update_streamlings_saved_label():
	if Global.active_level:
		$StreamlingSavedLabel.text = "Streamlinge gerettet: %d von %d" % [Global.streamlings_saved, Global.active_level.lemming_threshold]

func show_winning_screen():
	$ScrollContainer.visible = false
	$UserListHeader.visible = false
	$StreamlingSavedLabel.visible = false
	$Resources.visible = false

	$WinOverlay.visible = true
	$WinOverlay/Tween.interpolate_property($WinOverlay, "modulate", Color8(255, 255, 255, 0), Color8(255, 255, 255, 255), 2)
	$WinOverlay/Tween.start()

	$WinOverlay/WinningSound.play()

	$WinOverlay/LevelDoneTimer.start()

func _ready():
	update_streamlings_saved_label()

func _on_UserListUpdateTimer_timeout():
	update_user_list()

func _physics_process(_delta):
	update_streamlings_saved_label()
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
		Global.active_level = null
		Global.streamlings_saved = 0

func _on_LevelDoneTimer_timeout():
	emit_signal("level_done")
