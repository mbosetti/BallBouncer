extends Node

@export var num_players: int = 8
@export var bus: String = "master"

var _available = []
var queue = [] 


func _ready():
    for i in num_players:
        var p = AudioStreamPlayer.new()
        add_child(p)
        _available.append(p)
        p.finished.connect(_on_stream_finished.bind(p))
        p.bus = bus


func _on_stream_finished(stream):
    _available.append(stream)


func play(sound_path):
    queue.append(sound_path)


func _process(delta):
    if not queue.is_empty() and not _available.is_empty():
        _available[0].stream = load(queue.pop_front())
        _available[0].play()
        _available.pop_front()