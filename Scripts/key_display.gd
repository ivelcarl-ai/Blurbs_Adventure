extends CanvasLayer

@onready var slot1: Sprite2D = $Control/ColorRect/slot1
@onready var slot2: Sprite2D = $Control/ColorRect/slot2
@onready var slot3: Sprite2D = $Control/ColorRect/slot3
@onready var key: CompressedTexture2D = preload("res://Art/Sprites/key.png")

func update_display() -> void:
	var number_of_keys = GameData.get_keys()
	
	if number_of_keys == 0:
		slot1.visible = false
		slot2.visible = false
		slot3.visible = false
	elif number_of_keys == 1:
		slot1.visible = true
		slot2.visible = false
		slot3.visible = false
	elif number_of_keys == 2:
		slot1.visible = true
		slot2.visible = true
		slot3.visible = false
	elif number_of_keys == 3:
		slot1.visible = true
		slot2.visible = true
		slot3.visible = true
