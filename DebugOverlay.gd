extends Control

var game: Game
var lemmings = []

func _ready():
	randomize()
	yield(owner, "ready")
	game = owner as Game

func _on_SpawnButton_pressed():
	var name = str(randi())
	lemmings.append(name)
	game.create_lemming(name)

func _on_UmbrellaButton_pressed():
	for lemming in lemmings:
		game.umbrella(lemming)

func _on_KillButton_pressed():
	for lemming in lemmings:
		game.kill(lemming)

func _on_OutButton_pressed():
	for lemming in lemmings:
		game.out(lemming)

func _on_BlockButton_pressed():
	for lemming in lemmings:
		game.block(lemming)

func _on_WalkButton_pressed():
	for lemming in lemmings:
		game.walk(lemming)

func _on_DigButton_pressed():
	for lemming in lemmings:
		game.dig(lemming)

func _on_ToggleState_pressed():
	game.show_state = !game.show_state

func _on_Close_pressed():
	visible = false
