extends Node2D

@onready var coinDisplay = $"../../CoinsDisplay"
@export var coinAudio : AudioStreamMP3

func _on_area_2d_body_entered(body: Node2D) -> void:
	GameData.addCoin()
	
	if coinDisplay != null:
		coinDisplay.updateDisplay()
	body.playSound("coin")
	
	queue_free()
