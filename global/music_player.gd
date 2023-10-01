extends Node

## A queue-based music player.
## This node is typically global and autoloaded.


const AUDIO_BUS: String = "Music"

var _player: AudioStreamPlayer
var _songs: Array[AudioStream] = []
var _song_index: int = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Play audio even when paused.
	_player = AudioStreamPlayer.new()
	add_child(_player)
	_player.bus = AUDIO_BUS
	_player.finished.connect(_on_music_finished)


func play(songs: Array[AudioStream]) -> void:
	_songs = songs
	_song_index = wrapi(_song_index, 0, len(_songs))
	if not _player.playing:
		_play_next_song()


func _play_next_song() -> void:
	_player.stream = _songs[_song_index]
	_player.play()
	_song_index = wrapi(_song_index + 1, 0, len(_songs))


func _on_music_finished() -> void:
	_play_next_song()
