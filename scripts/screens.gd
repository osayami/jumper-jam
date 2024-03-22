extends CanvasLayer

signal start_game
signal delete_level
signal purchase_skin

@onready var console_log = $Debug/ConsoleLog

@onready var title_screen = $TitleScreen
@onready var pause_screen = $PauseScreen
@onready var game_over_screen = $GameOverScreen
@onready var shop_screen = $ShopScreen

@onready var gameover_score_label = $GameOverScreen/Box/ScoreLabel
@onready var gameover_high_score_label = $GameOverScreen/Box/HighScoreLabel

var current_screen = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	console_log.visible = false
	register_buttons()
	change_screen(title_screen)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_toggleconsole_pressed():
	console_log.visible = !console_log.visible
	
func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	if buttons.size() > 0:
		for button in buttons:
			if button is ScreenButton:
				button.clicked.connect(_on_button_pressed)
				
func _on_button_pressed(button):
	SoundFX.play("Click")
	match button.name:
		"TitlePlay":
			change_screen(null)
			await get_tree().create_timer(0.5).timeout
			start_game.emit()
		"TitleShop":
			change_screen(shop_screen)
		
		"PauseRetry":
			change_screen(null)
			await get_tree().create_timer(0.75).timeout
			get_tree().paused = false
			start_game.emit()
		"PauseBack":
			change_screen(title_screen)
			get_tree().paused = false
			delete_level.emit()
			
		"PauseClose":
			change_screen(null)
			await get_tree().create_timer(0.75).timeout
			get_tree().paused = false
		"GameOverRetry":
			change_screen(null)
			await get_tree().create_timer(0.5).timeout
			start_game.emit()
			
		"GameOverBack":
			change_screen(title_screen)
			delete_level.emit()
		"ShopBack":
			change_screen(title_screen)
		"ShopPurchaseSkin":
			purchase_skin.emit()
		
func change_screen(new_screen):
	if current_screen:
		var disappear_tween = current_screen.disappear()
		await disappear_tween.finished
		current_screen.visible = false
		
	current_screen = new_screen
	if current_screen:
		var appear_tween = current_screen.appear()
		await appear_tween.finished
		get_tree().call_group("buttons","set_disabled",false)
		
func game_over(score,highscore):
	gameover_score_label.text = "Score: "+str(score)
	gameover_high_score_label.text = "Best: "+str(highscore)
	change_screen(game_over_screen)
	
func pause_game():
	change_screen(pause_screen)
	
	
