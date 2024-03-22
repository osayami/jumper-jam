extends Control

signal pause_game

@onready var topbar_bg = $TopBarBG
@onready var topbar = $TopBar
@onready var score_label = $TopBar/ScoreLabel


func _ready():
	var os_name = OS.get_name() 
	if os_name == "Android" or os_name == "iOS":
		var safe_area = DisplayServer.get_display_safe_area()
		var safe_area_top = safe_area.position.y
		
		Utility.add_log_msg("Safe area top before scale: "+ str(safe_area_top))
		
		if os_name == "iOS":
			var screen_scale = DisplayServer.screen_get_scale()
			Utility.add_log_msg("Screen scale: " + str(screen_scale))
		
			safe_area_top = (safe_area_top / screen_scale)
			
		topbar.position.y += safe_area_top
		var margin = 10
		topbar_bg.size.y += safe_area_top + margin
		
		Utility.add_log_msg("Safe area: "+ str(safe_area))
		Utility.add_log_msg("Window size: "+ str(DisplayServer.window_get_size()))
		Utility.add_log_msg("Safe area top: "+ str(safe_area_top))
		Utility.add_log_msg("Top bar pos: "+ str(topbar.position))
		

func _on_pause_button_pressed():
	pause_game.emit()

func set_score(new_score:int):
	score_label.text = str(new_score)
	
