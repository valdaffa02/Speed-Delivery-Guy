extends Sprite2D

@onready var bubble_sprite = $BubbleSprite
@onready var box_sprite = $BoxSprite
@onready var demand_cooldown_timer = $DemandCooldownTimer

var box_index: int = 0
var player: CharacterBody2D = null


# Called when the node enters the scene tree for the first time.
# Upon ready randomize the demanded delivery box
func _ready():
	randomize_box()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Scan for player's input when player is detected
	if player and Input.is_action_just_pressed("interact"):
		#print(player.box_index, " == ", box_index)
		receive_box()

# Randomize the demanded box by changing the sprite frame's index using random integer
func randomize_box() -> void:
	box_index = randi_range(0, 3)
	box_sprite.frame = box_index

# Function for NPC to receive box
func receive_box():
	# If player's box index isn't invalid
	if player.box_index >= 0:
		# If player's box index matchs with NPC's demand, hide the demand's visual cue, reset player's box index, add score via signal, and start cooldown timer
		if player.box_index == box_index:
			bubble_sprite.visible = false
			box_sprite.visible = false
			player.box_index = -1
			player.score_added.emit()
			player.play_give_sfx()
			demand_cooldown_timer.start()
		else:
			pass
	else:
		pass

# If player entered NPC's area2D, get the player reference and unhide player's interaction cue
func _on_npc_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		body.interaction_label.visible = true

# If player exited NPC's area2D, remove player reference and hide player's interaction cue
func _on_npc_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		body.interaction_label.visible = false
		player = null

# When demand cooldown timer ended, get new randomized demand, unhide the demand's visual cue, and randomize the next wait time
func _on_demand_cooldown_timer_timeout():
	randomize_box()
	bubble_sprite.visible = true
	box_sprite.visible = true
	demand_cooldown_timer.wait_time = randi_range(15, 17)
