extends Node2D

@onready var key_display = $"../../KeyDisplay"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_meta("Role") != "Player":
		return
	
	body.playSound("keyCollected")
	GameData.collect_key()
	key_display.update_display()
	queue_free()
