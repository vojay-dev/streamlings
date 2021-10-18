extends Control

signal reset_level

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

func _ready():
	update_streamlings_saved_label()

func _on_UserListUpdateTimer_timeout():
	update_user_list()

func _physics_process(_delta):
	update_streamlings_saved_label()
	$EnableFullscreen.visible = !OS.window_fullscreen
	$DisableFullscreen.visible = OS.window_fullscreen and not OS.has_feature("web")

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
