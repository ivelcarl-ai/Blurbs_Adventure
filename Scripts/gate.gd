extends Node2D

@onready var key_display = $"../../KeyDisplay"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_meta("Role") != "Player":
		return
	
	if GameData.has_key():
		GameData.use_key()
		key_display.update_display()
		body.playSound("gateUnlocked")
		queue_free()
	
