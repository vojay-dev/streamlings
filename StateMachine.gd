class_name StateMachine
extends Node

export var initial_state := NodePath()
onready var state: State = get_node(initial_state)

func _ready():
	yield(owner, "ready")

	for state in get_children():
		state.streamling = owner as Streamling
		state.state_machine = self

	state.enter()

func _physics_process(delta):
	state.physics_process(delta)

func transition_to(target_state_name: String):
	if not has_node(target_state_name):
		print("no state with name %s" % [target_state_name])
		return

	state.exit()
	state = get_node(target_state_name)
	state.enter()
	
	owner.set_state(state.get_name())
