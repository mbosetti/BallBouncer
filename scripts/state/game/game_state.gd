class_name GameState
extends State

var game

func _ready():
    game = get_tree().get_first_node_in_group("Game")
