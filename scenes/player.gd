extends CharacterBody2D

# Variables of child nodes
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree

@onready var debug_label = $DebugLabel
@onready var interaction_label = $InteractionLabel

@onready var player_sprite = $PlayerSprite
@onready var box_sprite = $PlayerSprite/BoxSprite

@onready var run_dust_particle = $RunDustParticle

@onready var pickup_box_sfx = $PickupBoxSFX
@onready var give_box_sfx = $GiveBoxSFX

const SPEED = 500.0

var box_index: int = -1
var direction: float = 0
var look_direction: float = 0

var current_animation: String = "idle"

# Initial variables as reference to reset player to initial parameters
var initial_position: Vector2 = Vector2.ZERO
var initial_scale: Vector2 = Vector2.ZERO

# Signal for adding score
signal score_added


func _ready():
	initial_position = global_position
	initial_scale = scale
	animation_tree.active = true


func _process(delta):
	# If player's box index is of invalid value (negative), player isn't carrying anything
	if box_index < 0:
		box_sprite.visible = false
		if direction == 0:
			change_animation("idle")
		elif direction != 0:
			change_animation("walk")
	# If player's box index is of valid value (positive), player is carrying a box
	else:
		box_sprite.frame = box_index
		box_sprite.visible = true
		if direction == 0:
			change_animation("idle_carry")
		elif direction != 0:
			change_animation("walk_carry")
	
	#debug_label.text = "box index: " + str(box_index)
	# Update animation tree's blend position using look_direction
	update_blend_position(look_direction)


func _physics_process(delta):
	# Move character body based on direction value
	direction = Input.get_axis("move_left", "move_right")
	# If direction's value exist assign the value to look direction for updating animation tree's blend position, emit particle, and move the character
	if direction:
		look_direction = direction
		run_dust_particle.set_emitting(true)
		
		velocity.x = direction * SPEED
	# If value is zero, turn off emit particle
	else:
		run_dust_particle.set_emitting(false)
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

# Change animation_tree's node state machine parameters based on the animation going to be played
func change_animation(animation_name):
	if animation_name == "idle":
		current_animation = "idle"
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/is_idle_carry"] = false
		animation_tree["parameters/conditions/is_walking_carry"] = false
	elif animation_name == "walk":
		current_animation = "walk"
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_walking"] = true
		animation_tree["parameters/conditions/is_idle_carry"] = false
		animation_tree["parameters/conditions/is_walking_carry"] = false
	elif animation_name == "idle_carry":
		current_animation = "idle_carry"
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/is_idle_carry"] = true
		animation_tree["parameters/conditions/is_walking_carry"] = false
	elif animation_name == "walk_carry":
		current_animation = "walk_carry"
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/is_idle_carry"] = false
		animation_tree["parameters/conditions/is_walking_carry"] = true
	else:
		pass

# Update animation_tree's blend position for changing between directional animation of the same type
func update_blend_position(direction):
	animation_tree["parameters/Idle/blend_position"] = direction
	animation_tree["parameters/Walk/blend_position"] = direction
	animation_tree["parameters/IdleCarry/blend_position"] = direction
	animation_tree["parameters/WalkCarry/blend_position"] = direction

# Reset player to initial parameters
func reset():
	global_position = initial_position
	scale = initial_scale
	box_index = -1
	current_animation = "idle"

# To play AudioStream for picking up box from the van SFX
func play_pickup_sfx():
	pickup_box_sfx.play()

# To play AudioStream for giving box to receiving NPC SFX
func play_give_sfx():
	give_box_sfx.play()
