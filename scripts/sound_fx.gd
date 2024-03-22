extends Node

@onready var sound_players = get_children()

var sounds = {
	"Click":preload("res://assets/sound/Click.wav"),
	"Fall":preload("res://assets/sound/Fall.wav"),
	"Jump":preload("res://assets/sound/Jump.wav")
}

func play(sound_name):
	var sound_to_play = sounds[sound_name]
	
	for sound_player in sound_players:
		if !sound_player.playing:
			sound_player.stream = sound_to_play
			sound_player.play()
			return
	print("too many sounds playing at once , not enough sound players!")
