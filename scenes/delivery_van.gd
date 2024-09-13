extends StaticBody2D

@onready var boxes_container = $BoxesHBoxContainer

@onready var box_0_button = $BoxesHBoxContainer/Box0Button
@onready var box_1_button = $BoxesHBoxContainer/Box1Button
@onready var box_2_button = $BoxesHBoxContainer/Box2Button
@onready var box_3_button = $BoxesHBoxContainer/Box3Button


var player: CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Detect player and set reference to player so player interaction with van can be limited only when it's inside van's interaction area2d
func _on_van_interaction_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player = body

# De-reference player when it exited van's interaction area2d
func _on_van_interaction_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player = null

# Assign content of box 0 button to player and randomize the next content of the button
func _on_box_0_button_pressed():
	if player and box_0_button.box_index >= 0:
		player.box_index = box_0_button.box_index
		player.play_pickup_sfx()
		box_0_button.randomize_button_content()

# Assign content of box 1 button to player and randomize the next content of the button
func _on_box_1_button_pressed():
	if player and box_1_button.box_index >= 0:
		player.box_index = box_1_button.box_index
		player.play_pickup_sfx()
		box_1_button.randomize_button_content()

# Assign content of box 2 button to player and randomize the next content of the button
func _on_box_2_button_pressed():
	if player and box_2_button.box_index >= 0:
		player.box_index = box_2_button.box_index
		player.play_pickup_sfx()
		box_2_button.randomize_button_content()

# Assign content of box 3 button to player and randomize the next content of the button
func _on_box_3_button_pressed():
	if player and box_3_button.box_index >= 0:
		player.box_index = box_3_button.box_index
		player.play_pickup_sfx()
		box_3_button.randomize_button_content()
