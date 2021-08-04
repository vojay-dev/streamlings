extends Control

onready var game: Game = owner as Game

func update_user_list():
	$UserListHeader.text = "Aktive Streamlinge (%d):" % [game.streamlings.size()]

	var text = ""

	for streamling in game.streamlings:
		text += "%s\n" % [streamling]

	$UserList.text = text

func update_streamlings_saved_label():
	$StreamlingSavedLabel.text = "Streamlinge gerettet: %d von %d" % [Global.streamlings_saved, Global.streamlings_threshold]

func _ready():
	update_streamlings_saved_label()

func _on_UserListUpdateTimer_timeout():
	update_user_list()
