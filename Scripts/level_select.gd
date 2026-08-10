extends Control

@export var back: Button
@export var level1: Button
@export var level2: Button
@export var level3: Button
@export var level4: Button
@export var level5: Button
@export var level6: Button
@export var level7: Button
@export var level8: Button
@export var level9: Button
@export var level10: Button
@export var audio: AudioStreamPlayer

@export var camera: Camera2D

var buttons: Array

func _ready() -> void:
	buttons = [level1, level2, level3, level4, level5, level6, level7, level8, level9, level10, back]
	camera.make_current()
	audio.seek(GameData.getLobbyAudioPosition())
	
func _process(_delta: float) -> void:
	updateButtonScale()

func updateButtonScale():
	for button in buttons:
		if button != null:
			buttonHover(button)

func buttonHover(button: Button):
	button.pivot_offset = button.size / 2
	
	var tween: Tween = create_tween()
	if button.is_hovered():
		tween.tween_property(button, "scale", Vector2.ONE * 1.2, 0.2)
	else:
		tween.tween_property(button, "scale", Vector2.ONE, 0.2)

func saveAudioPosition() -> void:
	var audioPosition = audio.get_playback_position()
	GameData.setLobbyAudioPosition(audioPosition)

func _on_back_pressed() -> void:
	saveAudioPosition()
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")

func reset_lobby() -> void:
	GameData.setLobbyAudioPosition(0)

func _on_level_1_pressed() -> void:
	reset_lobby()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1_prototype.tscn")

func _on_level_2_pressed() -> void:
	reset_lobby()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_2_prototype.tscn")

func _on_level_3_pressed() -> void:
	reset_lobby()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_3_prototype.tscn")

func _on_level_4_pressed() -> void:
	reset_lobby()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_4_prototype.tscn")

func _on_level_5_pressed() -> void:
	reset_lobby()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_5_prototype.tscn")

func _on_level_6_pressed() -> void:
	reset_lobby()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_6_prototype.tscn")

func _on_level_7_pressed() -> void:
	reset_lobby()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_7_prototype.tscn")

func _on_level_8_pressed() -> void:
	reset_lobby()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_8_prototype.tscn")

func _on_level_9_pressed() -> void:
	reset_lobby()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_9_prototype.tscn")

func _on_level_10_pressed() -> void:
	reset_lobby()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_10_prototype.tscn")
