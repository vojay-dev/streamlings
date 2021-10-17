extends Node2D

func _ready():
	$Rays.modulate = Color8(255, 255, 255, 0)
	$Door.play()

	$Rays/Tween.interpolate_property(
		$Rays,
		"modulate",
		Color8(255, 255, 255, 0),
		Color8(255, 255, 255, 255),
		1,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		2
	)
	$Rays/Tween.start()

func get_spawn_position():
	return $Position.global_position
