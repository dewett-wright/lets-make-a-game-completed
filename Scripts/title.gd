extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/AnimatedSprite2D.play("move")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	$TitleUI/Control/Play.visible = false
	$TitleUI/Control/Title.visible = false
	$TitleUI/Control/LevelSelectLabel.visible = true
	$TitleUI/Control/LevelSelect.visible = true


func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")


func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_2.tscn")


func _on_level_3_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_3.tscn")
