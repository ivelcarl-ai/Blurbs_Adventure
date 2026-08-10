extends Node2D

@onready var message: CanvasLayer = $Message
@onready var timer: Timer = $Timer
@onready var level: Node2D = $".."

func _on_area_2d_body_entered(body: Node2D) -> void:
	message.visible = true
	body.set_meta("canMove", false)
	
	timer.start()
	
	body.get_child(6).emitting = true
	body.get_child(4).visible = false
	
	level.canRestart = false


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
