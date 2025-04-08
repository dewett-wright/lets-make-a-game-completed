extends HBoxContainer

var is_dead : bool = false
const health_empty_texture = preload("res://Assets/kenney_pixel-platformer/Tiles/tile_0046.png")
const health_full_texture = preload("res://Assets/kenney_pixel-platformer/Tiles/tile_0044.png")  # You need a different texture for full hearts

# Called when the node enters the scene tree for the first time.
func _ready():
	update_health_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_health_display()

func update_health_display():
	# First, make sure we have access to our heart sprites
	var heart1 = get_node("Heart")
	var heart2 = get_node("Heart2")
	var heart3 = get_node("Heart3")
	
		# Update heart 1 (leftmost heart)
	if Globals.health >= 1:
		heart1.texture = health_full_texture
	else:
		heart1.texture = health_empty_texture

	# Update heart 2 (middle heart)
	if Globals.health >= 2:
		heart2.texture = health_full_texture
	else:
		heart2.texture = health_empty_texture
		
	if Globals.health >= 3:
		heart3.texture = health_full_texture
	else:
		heart3.texture = health_empty_texture
		
	# Handle death logic
	if Globals.health <= 0 and is_dead != true:
		is_dead = true
		Signals.emit_signal("player_died")
