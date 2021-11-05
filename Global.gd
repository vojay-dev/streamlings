extends Node

const STATE_FILE = "user://streamlings.dat"

var active_level
var selected_level
var levels

var level_time : int = 0
var streamlings_saved : int = 0

var channel : String = "vojay"
var mouse_enabled = false

var initial_window_size

var state = {
	"music_enabled": true,
	"level_times": {}
}

func is_music_enabled():
	return state["music_enabled"]

func set_music_enabled(music_enabled):
	state["music_enabled"] = music_enabled
	save_state()

func _ready():
	load_state()
	save_state()
	initial_window_size = OS.window_size
	#levels = get_levels()
	levels = [
		preload("res://Level1.tscn"),
		preload("res://Level2.tscn"),
		preload("res://Level3.tscn"),
		preload("res://Level4.tscn")
	]

func load_state():
	var file = File.new()

	if file.file_exists(STATE_FILE):
		print("loading state from file...")

		file.open(STATE_FILE, File.READ)
		state = file.get_var()

		print(state)
	else:
		print("loading default state...")
		print(state)

func save_state():
	var file = File.new()

	file.open(STATE_FILE, File.WRITE)
	file.store_var(state)
	file.close()

func enable_fullscreen():
	OS.window_fullscreen = true

func disable_fullscreen():
	OS.window_fullscreen = false
	OS.window_size = initial_window_size

func get_levels():
	var level_scenes = []
	var dir = Directory.new()

	dir.open(".")
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.begins_with("Level") and file.ends_with(".tscn"):
			level_scenes.append(load("res://" + file))

	dir.list_dir_end()

	return level_scenes

func update_level_time(level_name, time):
	if state["level_times"].has(level_name):
		var current_best = state["level_times"][level_name]
		if time < current_best:
			state["level_times"][level_name] = time
	else:
		state["level_times"][level_name] = time

	save_state()

func get_level_time(level_name):
	if state["level_times"].has(level_name):
		return state["level_times"][level_name]

	return null

func get_level_times():
	return state["level_times"]

func reset():
	active_level = null
	streamlings_saved = 0
	level_time = 0
