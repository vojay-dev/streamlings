extends Control

var background : Sprite

func _ready():
	var level_select = $CenterContainer2/GridContainer/LevelSelect

	for i in Global.levels.size():
		var file = Global.levels[i].resource_path
		var name = file.trim_prefix("res://").trim_suffix(".tscn")
		level_select.add_item(name, i)

	level_select.select(0)
	Global.selected_level = Global.levels[0]
	_set_background(Global.selected_level)
	
	$Streamling1.set_name("Choose a level and click start")
	$Streamling1.activate_umbrella()
	$Streamling2.set_name("gl")
	$Streamling2.block()
	$Streamling3.set_name("hf")
	$Streamling3.block()

func _on_Button_pressed():
	Global.channel = $CenterContainer/GridContainer/ChannelInput.text
	if Global.channel.length() == 0:
		Global.channel = "vojay"

	get_tree().change_scene("res://Game.tscn")

func _set_background(level):
	var instance = level.instance()
	var level_sprite : Sprite = instance.get_node("LevelSprite").duplicate()
	instance.queue_free()

	level_sprite.z_index = -1
	level_sprite.modulate = Color8(255, 255, 255, 100)

	background = level_sprite
	call_deferred("add_child", level_sprite)

func _on_LevelSelect_item_selected(index):
	$Flash/Tween.interpolate_property($Flash, "modulate", Color8(0, 0, 0, 255), Color8(0, 0, 0, 0), .4)
	$Flash/Tween.start()
	
	if background:
		background.queue_free()

	Global.selected_level = Global.levels[index]
	_set_background(Global.selected_level)
