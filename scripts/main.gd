extends Node


@onready var game = $Game
@onready var screens = $Screens

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screens.start_game.connect(_on_screens_start_game)
	game.player_died.connect(_on_game_player_died)
	screens.delete_level.connect(_on_screens_delete_level)
	game.pause_game.connect(_on_game_pause_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_screens_start_game():
	game.new_game()
	
func _on_game_player_died(score,highscore):
	await get_tree().create_timer(0.75).timeout
	screens.game_over(score,highscore)

func _on_screens_delete_level():
	game.reset_game()

func _on_game_pause_game():
	get_tree().paused = true
	screens.pause_game()
