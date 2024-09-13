extends Control

@onready var game = preload("res://scenes/game.tscn")

@onready var top_score_label = $VBoxContainer/TopScoreLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.load_data()
	top_score_label.text = "Top Score: " + str(GameManager.get_top_score())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(game)


func _on_exit_button_pressed():
	get_tree().quit()
