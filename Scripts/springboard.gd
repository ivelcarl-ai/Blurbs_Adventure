extends Node2D

@export var extend: AnimatedSprite2D
@export var sound: AudioStreamPlayer2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_meta("Role") == "Player":
		body.velocity.y -= 1000
		extend.play()
		sound.play()
		
