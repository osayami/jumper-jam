extends Node


@onready var game = $Game
@onready var screens = $Screens

var game_in_progress = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.window_set_window_event_callback(_on_window_event)
	screens.start_game.connect(_on_screens_start_game)
	game.player_died.connect(_on_game_player_died)
	screens.delete_level.connect(_on_screens_delete_level)
	game.pause_game.connect(_on_game_pause_game)

func _on_window_event(event):
	match event:
		DisplayServer.WINDOW_EVENT_FOCUS_IN:
			print("Focus in")
			Utility.add_log_msg("Focus in")
			
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			if game_in_progress and !get_tree().paused:
				_on_game_pause_game()
				print("window out .. game pause")
			Utility.add_log_msg("Focus out")
			
		DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
			get_tree().quit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_screens_start_game():
	game_in_progress = true
	game.new_game()
	
func _on_game_player_died(score,highscore):
	game_in_progress = false	
	await get_tree().create_timer(0.75).timeout
	screens.game_over(score,highscore)
	

func _on_screens_delete_level():
	game_in_progress = false	
	game.reset_game()

func _on_game_pause_game():
	get_tree().paused = true
	screens.pause_game()
	
	
