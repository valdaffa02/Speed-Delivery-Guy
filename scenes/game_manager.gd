extends Node

const SAVE_PATH: String = "user://GameData.save"


var top_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Top score setter
func set_top_score(score):
	top_score = score

# Top score getter
func get_top_score() -> int:
	return top_score

# Save top_score data to file
func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(top_score)

# Load top_score data from file
func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		top_score = file.get_var(top_score)
	else:
		print("no save data found!")
