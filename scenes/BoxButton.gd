extends Button

@onready var box_texture_rect = $MarginContainer/TextureRect

var box_textures = [
	"res://assets/images/delivery_box_0.png",
	"res://assets/images/delivery_box_1.png",
	"res://assets/images/delivery_box_2.png",
	"res://assets/images/delivery_box_3.png",
]

var box_index = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_button_content()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Hide box texture if the box index is invalid, unhide if valid
	if box_index < 0:
		box_texture_rect.visible = false
	else:
		box_texture_rect.visible = true

# Randomize box type in button
func randomize_button_content():
	box_index = randi_range(0, 3)
	# Load box texture based on the randomized index from box_textures array
	var texture_image: Texture = load(box_textures[box_index])
	box_texture_rect.texture = texture_image
