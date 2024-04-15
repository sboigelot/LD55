extends Node

signal MusicStarts

onready var audio:AudioStreamPlayer = $AudioStreamPlayer

export var auto_play:bool = true
export var play_on_start:bool = false
export var playing_index = -1
export var random:bool = true
export (String) var bus_name:String = 'Music'	

export var current_song_title = ""

var rng = RandomNumberGenerator.new()

export(Array, Resource) var playlist

export var previous_random_picks = []

func _ready():
	rng.randomize()
	audio.connect("finished", self, "on_audio_finished")
	if play_on_start:
		if playing_index == -1:
			on_audio_finished()
		else:
			play_index(playing_index)
		
func play(music:AudioStream)->void:
	emit_signal("MusicStarts", current_song_title)
	audio.stream = music
	audio.bus = bus_name
	audio.play()
	
func stop()->void:
	if audio.playing:
		audio.stop()
	else:
		on_audio_finished()
	
func on_audio_finished():
	if not auto_play:
		return
	play_next_music()
	
func play_next_music():
	if playlist.size() == 0:
		return
		
	if not random:
		playing_index = (playing_index + 1) % playlist.size()
	else:
		
		var possible_index = []
		for i in range(0, playlist.size()):
			if not previous_random_picks.has(i):
				possible_index.append(i)
				
		if possible_index.size() == 0:
			previous_random_picks.clear()
			possible_index = range(0, playlist.size())
			
		playing_index = possible_index[rng.randi() % possible_index.size()]
		previous_random_picks.append(playing_index)
	
	play_index(playing_index)
	
func play_index(playing_index):
	var file_path = playlist[playing_index].resource_path
	var audio_stream = load(file_path) as AudioStream
	current_song_title = file_path.replace("res://Sounds/Musics/","")

	play(audio_stream)
