class_name Streamling
extends KinematicBody2D

signal die

const COLLISION_LAYER_NORMAL = 0b00000000000000000010
const COLLISION_LAYER_COLLIDE = 0b00000000000000000100

var streamling_name = ""

var velocity = Vector2.ZERO

var gravity = 2
var direction = 1

var umbrella_activated = false
var alive = true
var saved = false

var game

func _ready():
	$OutAnimation.visible = false

func set_state(state):
	$Labels/Rows/StateLabel.text = str(state)

func activate_umbrella():
	if alive:
		$Labels/Rows/NameContainer/UmbrellaIcon.visible = true
		umbrella_activated = true

func deactivate_umbrella():
	if alive:
		$Labels/Rows/NameContainer/UmbrellaIcon.visible = false
		umbrella_activated = false

func set_name(name, position=0):
	streamling_name = name
	$Labels/Rows/NameContainer/NameLabel.text = streamling_name

func activate_collision():
	collision_layer = COLLISION_LAYER_COLLIDE

func deactivate_collision():
	collision_layer = COLLISION_LAYER_NORMAL

func play(animation):
	$Animations.play(animation)

func play_out():
	$OutAnimation.visible = true
	$OutAnimation.play("default")
	$Animations.visible = false
	$Labels.visible = false

func out():
	$StateMachine.transition_to("Out")

func kill():
	$StateMachine.transition_to("Die")

func walk():
	$StateMachine.transition_to("Walk")

func block():
	$StateMachine.transition_to("Block")

func dig():
	$StateMachine.transition_to("Dig")

func build():
	if down_collision():
		$StateMachine.transition_to("Build")

func emit_dig_particles():
	$DigParticles/DigParticles1.emitting = true
	$DigParticles/DigParticles2.emitting = true

func down_collision():
	return $RayCastDown.is_colliding()

func _physics_process(_delta):
	$Labels/Rows/StateLabel.visible = game and game.show_state

	if not alive or saved:
		return

	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, deg2rad(80))

func _on_OutAnimation_animation_finished():
	if not alive:
		die()

func _on_Animations_animation_finished():
	if $Animations.animation == "hit_ground" and not alive:
		die()

func shrink():
	saved = true
	$Animations.play("air")
	$AnimationPlayer.play("shrink")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shrink":
		queue_free()

func die():
	emit_signal("die", streamling_name)
	queue_free()

