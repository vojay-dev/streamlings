extends Control

func _on_Button_pressed():
	Global.channel = $CenterContainer/GridContainer/ChannelInput.text
	if Global.channel.length() == 0:
		Global.channel = "vojay"

	get_tree().change_scene("res://Game.tscn")
