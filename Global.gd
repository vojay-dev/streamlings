extends Node

var active_level
var selected_level
var levels

var streamlings_saved : int = 0

var channel : String = "vojay"
var mouse_enabled = false

var initial_window_size

func _ready():
	initial_window_size = OS.window_size
	#levels = get_levels()
	levels = [
		preload("res://Level1.tscn"),
		preload("res://Level2.tscn"),
		preload("res://Level3.tscn")
	]

func enable_fullscreen():
	OS.window_fullscreen = true

func disable_fullscreen():
	OS.window_fullscreen = false
	OS.window_size = initial_window_size

func get_levels():
	var levels = []
	var dir = Directory.new()

	dir.open(".")
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.begins_with("Level") and file.ends_with(".tscn"):
			levels.append(load("res://" + file))

	dir.list_dir_end()

	return levels
