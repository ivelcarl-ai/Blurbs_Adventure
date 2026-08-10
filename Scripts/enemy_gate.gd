extends Node2D

@export var threshold : int = 3

func _process(_delta: float) -> void:
	if GameData.getEnemiesKilled() >= threshold:
		queue_free()
