extends Node

## A queue-based audio stream player.
## Multiple concurrent streams can be played at once.
## This node is typically global and autoloaded.


const STREAM_COUNT: int = 7  # One less than total streams.
const AUDIO_BUS: String = "Sound"

var _available: Array[AudioStreamPlayer] = []
var _queue: Array[AudioStream] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Play audio even when paused.

	for i in range(0, STREAM_COUNT):
		var player := AudioStreamPlayer.new()
		add_child(player)
		_available.append(player)
		player.finished.connect(_on_stream_finished.bind(player))
		player.bus = AUDIO_BUS


func _process(_delta: float) -> void:
	while not _queue.is_empty() and not _available.is_empty():
		var player = _available.pop_back()
		player.stream = _queue.pop_front()
		player.play()


func play(stream: AudioStream) -> void:
	_queue.append(stream)


func _on_stream_finished(player: AudioStreamPlayer) -> void:
	_available.push_back(player)
