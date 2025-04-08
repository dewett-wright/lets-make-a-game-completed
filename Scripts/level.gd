extends Node2D

@export var coins_to_collect : int = 5
@export var time_limit : int = 60

var coins_collected : int = 0
var time_left : float
var game_active : bool = false
var countdown_active : bool = false
var game_started : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("coin_collected", Callable(self, "collect_coin"))
	Globals.coins_collected = 0
	Globals.health = 3
	time_left = time_limit
	
		# Update UI
	$UI/Timer.text = "Time: " + str(time_limit)
	$UI/CoinCount.text = "Coins: 0/" + str(coins_to_collect)

	$UI/StartPrompt.show()
	$UI/Countdown.hide()
	
	get_tree().call_group("player", "set_physics_process", false)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !game_started && !countdown_active && (Input.is_action_just_pressed("ui_accept") || 
		Input.is_action_just_pressed("ui_left") || 
		Input.is_action_just_pressed("ui_right") || 
		Input.is_action_just_pressed("ui_up") || 
		Input.is_action_just_pressed("ui_down")):
		start_countdown()
		
			# Handle countdown
	if countdown_active:
		return
		
	# Handle game timer
	if game_active:
		time_left -= delta
		$UI/Timer.text = "Time Left: " + str(int(time_left))
		
		if time_left <= 0:
			on_time_expired()

func start_countdown():
	$AudioStreamPlayer.stream = load("res://Assets/8-Bit jingles/jingles_NES01.ogg")
	$AudioStreamPlayer.play()
	$UI/StartPrompt.hide()
	$UI/Countdown.show()
	countdown_active = true

	$UI/Countdown/AnimationPlayer.play("countdown")
	await $UI/Countdown/AnimationPlayer.animation_finished
	
	$UI/Countdown.hide()
	countdown_active = false
	game_started = true
	game_active = true

	get_tree().call_group("player", "set_physics_process", true)

func collect_coin():
	$AudioStreamPlayer.stream = load("res://Assets/8-Bit jingles/jingles_NES02.ogg")
	$AudioStreamPlayer.play()
	$UI/CoinCount.text = "Coins: " + str(Globals.coins_collected) + "/" + str(coins_to_collect)
	
	if Globals.coins_collected >= coins_to_collect:
		on_level_completed()
		
func on_level_completed():
	game_active = false
	Signals.emit_signal("level_cleared")
	$AudioStreamPlayer.stream = load("res://Assets/8-Bit jingles/jingles_NES03.ogg")
	$AudioStreamPlayer.play()
	
func on_time_expired():
	game_active = false
	Signals.emit_signal("player_died")
	$UI/GameOver/AnimationPlayer.play("GameOver")
