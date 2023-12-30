class_name StateMachine
extends Node

@export var initial_state: State
@export var logging: bool = false

var current_state: State
var states: Dictionary = {}

func _ready():
	if logging:
		print("initial state: " + initial_state.name)
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_child_transitioned)
			if logging:
				print("Found state: " + child.name)

	if initial_state:
		if logging:
			print("entering initial state: " + initial_state.name)
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func _on_child_transitioned(state, new_state_name):
	if logging:
		print("transitioning from " + state.name + " to " + new_state_name + " with current state " + current_state.name)

	if state != current_state:
		if logging:
			print("Error: Cannot invoke state change from non current scene " + state.name)
		return

	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		if logging:
			print("Error: Could not find new state: " + new_state_name.to_lower())
		return

	if current_state:
		if logging:
			print("exiting current state: " + current_state.name)
		current_state.exit()
		
	if logging:
		print("entering new state: " + new_state.name)
	
	current_state = new_state
	new_state.enter()
