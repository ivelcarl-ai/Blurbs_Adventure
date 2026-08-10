extends Area2D


@onready var level: Node2D = $".."
@onready var player: Node2D = $"../"
@onready var flag: AnimatedSprite2D = $Checkpoint

@export var checkpointClear: AudioStreamPlayer2D

var opened: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.get_meta("Role") == "Player" and !opened:
		flag.play("open")
		body.set_last_checkpoint(self)
		opened = true
		checkpointClear.play()
