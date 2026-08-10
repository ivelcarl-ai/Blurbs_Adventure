extends Area2D

@onready var winScreen: Control = $"../Menus/WinScreen"
@onready var level: Node2D = $".."
@onready var flag: AnimatedSprite2D = $Flag

@export var levelClear: AudioStreamPlayer2D

var player: CharacterBody2D

func _on_body_entered(_body: Node2D) -> void:
	winScreen.openMenu()
	flag.play("open")
	player.set_meta("canMove", false)
	levelClear.play()
	
