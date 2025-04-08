extends Node

var coins_collected : int = 0
var health : int = 3

var best_level_1_time : float = 0.00
var best_level_2_time : float = 0.00
var best_level_3_time : float = 0.00

# Dictionary to store best times (for future levels beyond 3)
var level_best_times : Dictionary = {}

# Save file path
const SAVE_PATH = "user://game_save.dat"

func _ready():
	# Load saved data when game starts
	load_game()

func get_best_time(level_number : int) -> float:
	# First check individual variables for levels 1-3
	if level_number == 1:
		return best_level_1_time
	elif level_number == 2:
		return best_level_2_time
	elif level_number == 3:
		return best_level_3_time
	else:
		# For higher levels, use the dictionary
		var level_key = "level_" + str(level_number)
		if level_best_times.has(level_key):
			return level_best_times[level_key]
		return 0.0
		
func set_best_time(level_number : int, time : float) -> void:
	# Set for individual variables for levels 1-3
	if level_number == 1:
		best_level_1_time = time
	elif level_number == 2:
		best_level_2_time = time
	elif level_number == 3:
		best_level_3_time = time
	else:
		# For higher levels, use the dictionary
		var level_key = "level_" + str(level_number)
		level_best_times[level_key] = time
	
	# Save game data whenever a best time is set
	save_game()
	

func get_level_number_from_path(path : String) -> int:
	var filename = path.get_file().get_basename()
	var level_parts = filename.split("_")
	if level_parts.size() >= 2 and level_parts[0] == "level":
		return int(level_parts[1])
	return 0
	
func save_game() -> void:
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"health": health,
			"coins_collected": coins_collected,
			"best_level_1_time": best_level_1_time,
			"best_level_2_time": best_level_2_time,
			"best_level_3_time": best_level_3_time,
			"level_best_times": level_best_times
		}
		
		# Convert dictionary to JSON string
		var json_string = JSON.stringify(save_data)
		# Save to file
		save_file.store_line(json_string)
		save_file.close()
		

func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if save_file:
			var json_string = save_file.get_line()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				var save_data = json.data
				
				# Load values if they exist
				if save_data.has("health"):
					health = save_data["health"]
				if save_data.has("coins_collected"):
					coins_collected = save_data["coins_collected"]
				if save_data.has("best_level_1_time"):
					best_level_1_time = save_data["best_level_1_time"]
				if save_data.has("best_level_2_time"):
					best_level_2_time = save_data["best_level_2_time"]
				if save_data.has("best_level_3_time"):
					best_level_3_time = save_data["best_level_3_time"]
				if save_data.has("level_best_times"):
					level_best_times = save_data["level_best_times"]
					
			save_file.close()
