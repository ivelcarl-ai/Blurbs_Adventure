extends Node2D

@export var deathParticles: GPUParticles2D
@export var rb: RigidBody2D
@export var playerKiller: Area2D
@export var death: AudioStreamPlayer2D

func _on_shot_detection_body_entered(body: Node2D) -> void:
	if body.get_meta("Role") == "Player":
		body.respawn()
	elif body.get_meta("Role") == "Shot":
		deathParticles.emitting = true
		playerKiller.queue_free()
		rb.alive = false
		GameData.killEnemy()
		death.play()
		body.linear_velocity = -body.linear_velocity
		rb.set_collision_layer_value(4, false)
