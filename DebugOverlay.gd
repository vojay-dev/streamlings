extends Control

const CommandInfo = preload("res://addons/gift/util/cmd_info.gd")
const SenderData = preload("res://addons/gift/util/sender_data.gd")

var game: Game
var lemmings = []

func _ready():
	randomize()
	yield(owner, "ready")
	game = owner as Game

func _create_command_info(name):
	var sender_data = SenderData.new(name, "", {})
	var command_info = CommandInfo.new(sender_data, "", false)
	
	return command_info

func _on_SpawnButton_pressed():
	var name = str(randi())
	lemmings.append(name)
	game.create_lemming(_create_command_info(name))

func _on_UmbrellaButton_pressed():
	for lemming in lemmings:
		game.umbrella(_create_command_info(lemming))

func _on_KillButton_pressed():
	for lemming in lemmings:
		game.kill(_create_command_info(lemming))

func _on_OutButton_pressed():
	for lemming in lemmings:
		game.out(_create_command_info(lemming))

func _on_BlockButton_pressed():
	for lemming in lemmings:
		game.block(_create_command_info(lemming))

func _on_WalkButton_pressed():
	for lemming in lemmings:
		game.walk(_create_command_info(lemming))

func _on_DigButton_pressed():
	for lemming in lemmings:
		game.dig(_create_command_info(lemming))

func _on_BuildButton_pressed():
	for lemming in lemmings:
		game.build(_create_command_info(lemming))

func _on_ToggleState_pressed():
	game.show_state = !game.show_state
	var modulate = Color8(56, 255, 45, 255) if game.show_state else Color.white
	$PanelContainer/GridContainer/ToggleState.modulate = modulate

func _on_ToggleMouse_pressed():
	Global.mouse_enabled = !Global.mouse_enabled
	var modulate = Color8(56, 255, 45, 255) if Global.mouse_enabled else Color.white
	$PanelContainer/GridContainer/ToggleMouse.modulate = modulate

func _on_Close_pressed():
	visible = false
