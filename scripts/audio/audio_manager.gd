extends Node

class Params:
	var sound_path: String
	var expiration: float
	var priority: int
	var pitch: float = 1.0

	func _init(sound_path: String, expiration: float = INF, priority: int = 100, pitch: float = 1.0):
		self.sound_path = sound_path
		self.expiration = expiration
		self.priority = priority
		self.pitch = pitch

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

func play(params: Params):
	queue.append(params)
	_sort_queue()

func _sort_priority(x, y):
	return x.priority < y.priority

func _sort_queue():
	queue.sort_custom(_sort_priority)

func _filter_expired(delta: float):
	for i in queue.size():
		if queue[i].expiration != null && queue[i].expiration <= 0.0:
			queue.remove(i)

func _process(delta):
	_filter_expired(delta)
	if not queue.is_empty() and not _available.is_empty():
		var param = queue.pop_front()
		_available[0].stream = load(param.sound_path)
		_available[0].play()
		_available[0].pitch_scale = param.pitch
		_available.pop_front()
