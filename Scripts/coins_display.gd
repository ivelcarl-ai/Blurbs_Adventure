extends CanvasLayer

@onready var label: Label = $ColorRect/Label

func updateDisplay() -> void:
	label.text = str(GameData.current_coins)
