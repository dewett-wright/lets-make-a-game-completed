extends Control

@export var audio : AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("player_died", Callable(self, "on_player_died"))

func on_player_died():
	audio.stream = load("res://Assets/8-Bit jingles/jingles_NES00.ogg")
	audio.play()
	$AnimationPlayer.play("GameOver")


func _on_respawn_pressed():
	get_tree().reload_current_scene()


func _on_title_pressed():
	get_tree().change_scene_to_file("res://Scenes/title.tscn")
