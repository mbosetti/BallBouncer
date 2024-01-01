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

func play(params: AudioClipParams):
	queue.append(params)
	_sort_queue()

func _sort_priority(x, y):
	return x.priority < y.priority

func _sort_queue():
	queue.sort_custom(_sort_priority)

func _filter_expired(delta: float):
	var i = queue.size()
	while i > 0:
		i -= 1
		if queue[i].expiration != -1:
			queue[i].expiration -= delta
			if queue[i].expiration <= 0.0:
				print("removing ", queue[i].sound_path)
				queue.remove_at(i)

func _process(delta):
	_filter_expired(delta)
	if not queue.is_empty() and not _available.is_empty():
		var param = queue.pop_front()
		_available[0].stream = load(param.sound_path)
		_available[0].play()
		_available[0].pitch_scale = param.pitch
		_available.pop_front()
