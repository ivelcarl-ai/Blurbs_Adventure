extends Control

@export var playButton: Button
@export var settingsButton: Button
@export var restartButton: Button
@export var audioButton: Button
@export var animator: AnimationPlayer
@export var startButton: Button
@export var clothingButton: Button
@export var homeButton: Button
@export var statsButton: Button
@export var blurbButton: Button
@export var boblinaButton: Button
@export var camera: Camera2D
@export var audioPlayer: AudioStreamPlayer

var buttons: Array 
var open: bool
var level: Node2D

func isOpen() -> bool:
	return open

func _ready() -> void:
	buttons = [playButton, settingsButton, restartButton, audioButton, startButton, clothingButton, homeButton, blurbButton, boblinaButton, statsButton]
	
	if audioPlayer != null:
		audioPlayer.seek(GameData.getLobbyAudioPosition())
	
	if camera != null:
		camera.make_current()
	
	if audioButton != null:
		if !GameData.audioOn:
			audioButton.button_pressed = true
			GameData.changeAudio()
	
	if get_parent() != $"/root":
		level = $"../.."
	
	setActivePlayer()

func setActivePlayer() -> void:
	if blurbButton != null:
		if GameData.current_player == "Blurb":
			blurbButton.button_pressed = true
		else:
			boblinaButton.button_pressed = true

func _process(_delta: float) -> void:
	updateButtonScale()

func _on_play_pressed() -> void:
	level.handlePauseMenu()

func _on_restart_pressed() -> void:
	level.restartLevel()

func _on_audio_toggled(_toggled_on: bool) -> void:
	GameData.changeAudio()

func _on_settings_pressed() -> void:
	level.handleSettingsMenu()

func _on_back_pressed() -> void:
	level.handleSettingsMenu()

func _on_next_level_pressed() -> void:
	level.changeToNextScene()

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

func openMenu() -> void:
	open = true
	visible = true
	animator.play("open")

func closeMenu() -> void:
	open = false
	animator.play("close")

func saveAudioPosition() -> void:
	var audioPosition = audioPlayer.get_playback_position()
	GameData.setLobbyAudioPosition(audioPosition)

func _on_start_pressed() -> void:
	saveAudioPosition()
	get_tree().change_scene_to_file("res://Scenes/Menus/level_select.tscn")

func _on_home_pressed() -> void:
	if audioPlayer != null:
		saveAudioPosition()
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")

func _on_blurb_pressed() -> void:
	GameData.current_player = "Blurb"
	boblinaButton.button_pressed = false
	blurbButton.button_pressed = true

func _on_boblina_pressed() -> void:
	GameData.current_player = "Boblina"
	blurbButton.button_pressed = false
	boblinaButton.button_pressed = true

func _on_clothing_pressed() -> void:
	saveAudioPosition()
	get_tree().change_scene_to_file("res://Scenes/Menus/clothing_menu.tscn")

func _on_home_settings_pressed() -> void:
	saveAudioPosition()
	get_tree().change_scene_to_file("res://Scenes/Menus/menu_settings.tscn")


func _on_stats_pressed() -> void:
	saveAudioPosition()
	get_tree().change_scene_to_file("res://Scenes/Menus/stats_menu.tscn")
