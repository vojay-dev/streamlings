extends Control

var background : Sprite

var streamling_names_index = 0
var streamling_names = [
	"Choose a level and click start",
	"Write commands in chat to control Streamlings",
	"Save enough Streamlings to win"
]

func _ready():
	var level_select = $CenterContainer2/GridContainer/LevelSelect

	for i in Global.levels.size():
		var file = Global.levels[i].resource_path
		var name = file.trim_prefix("res://").trim_suffix(".tscn")
		level_select.add_item(name, i)

	level_select.select(0)
	Global.selected_level = Global.levels[0]
	_set_background(Global.selected_level)

	$Streamling1.set_name(streamling_names[streamling_names_index])
	$Streamling1.activate_umbrella()
	$Streamling2.set_name("gl")
	$Streamling2.block()
	$Streamling3.set_name("hf")
	$Streamling3.block()
	$Streamling4.set_name("")

	$Logo/Tween.interpolate_property($Logo, "modulate", Color8(0, 0, 0, 255), Color8(255, 255, 255, 255), 2)
	$Logo/Tween.start()

	_start_streamling_name_timer()
	
	if Global.is_music_enabled():
		_start_music()
	else:
		_stop_music()

func _start_streamling_name_timer():
	var timer = Timer.new()
	timer.connect("timeout", self, "_on_streamling_name_timer_timeout")
	timer.set_wait_time(5)
	add_child(timer)
	timer.start()

func _on_streamling_name_timer_timeout():
	streamling_names_index += 1
	if streamling_names_index == streamling_names.size():
		streamling_names_index = 0

	$Streamling1.set_name(streamling_names[streamling_names_index])

func _physics_process(_delta):
	$EnableFullscreen.visible = !OS.window_fullscreen
	$DisableFullscreen.visible = OS.window_fullscreen and not OS.has_feature("web")

func _on_Button_pressed():
	Global.channel = $CenterContainer/GridContainer/ChannelInput.text
	if Global.channel.length() == 0:
		Global.channel = "vojay"

	var _error = get_tree().change_scene("res://Game.tscn")

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

func _on_EnableFullscreen_pressed():
	Global.enable_fullscreen()

func _on_DisableFullscreen_pressed():
	Global.disable_fullscreen()

func _set_toggle_music_texture():
	var playing = $AudioStreamPlayer.playing
	var texture = load("res://assets/ui/icons/music%s.png" % ("On" if playing else "Off"))

	$ToggleMusic.texture_normal = texture
	$ToggleMusic.texture_pressed = texture
	$ToggleMusic.texture_hover = texture
	$ToggleMusic.texture_disabled = texture
	$ToggleMusic.texture_focused = texture

func _start_music():
	$AudioStreamPlayer.play()
	Global.set_music_enabled(true)
	_set_toggle_music_texture()
	
func _stop_music():
	$AudioStreamPlayer.stop()
	Global.set_music_enabled(false)
	_set_toggle_music_texture()

func _on_ToggleMusic_pressed():
	if $AudioStreamPlayer.playing:
		_stop_music()
	else:
		_start_music()

func _on_HighscoreButton_pressed():
	$Highscores.visible = true
