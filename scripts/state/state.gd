class_name State
extends Node

signal transitioned

func transition_deferred(new_state: String):
    (func(): transitioned.emit(self, new_state)).call_deferred()

func enter():
    pass

func exit():
    pass

func update(delta: float):
    pass

func physics_update(delta: float):
    pass