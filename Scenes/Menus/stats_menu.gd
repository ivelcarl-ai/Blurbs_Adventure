extends Control

@export var home: Button
@export var settings: Button
@export var audioPlayer: AudioStreamPlayer

var buttons: Array

func _ready() -> void:
	buttons = [home, settings]
	
	if audioPlayer != null:
		audioPlayer.seek(GameData.getLobbyAudioPosition())

func _process(delta: float) -> void:
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
	var audioPosition = audioPlayer.get_playback_position()
	GameData.setLobbyAudioPosition(audioPosition)

func _on_menu_pressed() -> void:
	saveAudioPosition()
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")

func _on_back_pressed() -> void:
	saveAudioPosition()
	get_tree().change_scene_to_file("res://Scenes/Menus/menu_settings.tscn")
