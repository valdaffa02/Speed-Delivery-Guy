extends Node2D

# Reference to main menu scene
@onready var main_menu = load("res://scenes/main_menu.tscn")

# Canvas Layer's nodes variable
@onready var game_over_container = $CanvasLayer/GameOverContainer
@onready var pause_menu_container = $CanvasLayer/PauseMenuContainer
@onready var overlay_rect = $CanvasLayer/OverlayRect
@onready var score_label = $CanvasLayer/ScoreLabel

# Variables for timer and their visual cues
@onready var start_countdown_timer = $StartCountdownTimer
@onready var start_countdown_label = $CanvasLayer/StartCountdownLabel

@onready var game_timer = $GameTimer
@onready var game_timer_label = $CanvasLayer/GameTimerContainer/GameTimerLabel
@onready var game_timer_progress_bar = $CanvasLayer/GameTimerContainer/GameTimerProgressBar

# Reference to player
@onready var player = $Player

# Game score
var score: int = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect player's score_added signal to increase score function
	player.score_added.connect(increase_score)
	# Start start countdown timer and pause the game to prevent input and changes during countdown
	start_countdown_timer.start()
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	# update start countdown label and processes that's going on during countdown
	if !start_countdown_timer.is_stopped():
		# hide score label when countdown still going
		score_label.visible = false
		# snap countdown timer's time left by increment of 1 for label presentation
		start_countdown_label.text = str(snapped(start_countdown_timer.time_left, 1))
		# replace "0" with "Start" when the timer reach 0
		if start_countdown_label.text == "0":
			start_countdown_label.text = "Start!"
		# pause start countdown timer when the player paused during start countdown
		if Input.is_action_just_pressed("escape"):
			# pause/unpause the game along with hide/unhide the overlay
			get_tree().paused = !get_tree().paused
			overlay_rect.visible = !overlay_rect.visible
			# pause/unpause countdown timer along with hide/unhide the pause menu
			start_countdown_timer.set_paused(!start_countdown_timer.is_paused())
			pause_menu_container.visible = !pause_menu_container.visible
		
	# update game timer label, progress bar, and processes that's going on during the gameplay
	elif !game_timer.is_stopped():
		# unhide and update the score label while the gameplay going
		score_label.visible = true
		score_label.text = "Score: " + str(score)
		# snap game timer's time left by increment of 1 for label presentation and update the game timer's progress bar
		game_timer_label.text = "Time Left: " + str(snapped(game_timer.time_left, 0.1)) + "s"
		game_timer_progress_bar.value = game_timer.time_left
		# pause game timer when the player paused during the gameplay
		if Input.is_action_just_pressed("escape"):
			# pause/unpause the game along with hide/unhide the overlay
			get_tree().paused = !get_tree().paused
			overlay_rect.visible = !overlay_rect.visible
			# pause/unpause game timer along with hide/unhide the pause menu
			game_timer.set_paused(!game_timer.is_paused())
			pause_menu_container.visible = !pause_menu_container.visible
	

# When start countdown timer ended unpause the game, start game timer, and hide start countdown label
func _on_start_countdown_timer_timeout():
	get_tree().paused = false
	game_timer.start()
	start_countdown_label.visible = false

# When game timer ended, pause the game, unhide the overlay, and show the game over menu
func _on_game_timer_timeout():
	# If current game's score is bigger than the top score, replace the top score with the current score then save data
	if GameManager.get_top_score() < score:
		GameManager.set_top_score(score)
		GameManager.save_data()
	
	get_tree().paused = !get_tree().paused
	overlay_rect.visible = !overlay_rect.visible
	game_over_container.visible = true


# Change scene to main menu
func _on_main_menu_button_pressed():
	get_tree().change_scene_to_packed(main_menu)

# Unpause the game via continue button in pause menu
func _on_continue_button_pressed():
	get_tree().paused = false
	overlay_rect.visible = !overlay_rect.visible
	# If game paused during start countdown
	if !start_countdown_timer.is_stopped():
		start_countdown_timer.set_paused(!start_countdown_timer.is_paused())
		pause_menu_container.visible = !pause_menu_container.visible
	# If game paused during the gameplay
	elif !game_timer.is_stopped():
		game_timer.set_paused(!game_timer.is_paused())
		pause_menu_container.visible = !pause_menu_container.visible

# replay the game via game over menu
func _on_play_again_button_pressed():
	game_over_container.visible = false
	restart_game()

# increase score function, connected to player's score added signal
func increase_score():
	score += 1


# Restart game conditions
func restart_game() -> void:
	player.reset()
	score = 0
	
	# Restart the countdown timer
	start_countdown_timer.start()
	start_countdown_label.visible = true
	
	# Reset the game timer label and progress bar
	game_timer_label.text = "time left: 60.0s"
	game_timer_progress_bar.value = 60
	
	overlay_rect.visible = false
