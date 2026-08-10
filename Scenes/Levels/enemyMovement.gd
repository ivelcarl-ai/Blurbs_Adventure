extends RigidBody2D

@export var sprite : Sprite2D

@onready var leftSprite : CompressedTexture2D = preload("res://Art/Sprites/Enemy/Enemy2Left.png")
@onready var rightSprite : CompressedTexture2D = preload("res://Art/Sprites/Enemy/Enemy2Right.png")

var current_direction : String = "left"
var alive : bool = true

func _physics_process(_delta: float) -> void:
	if !alive: return
	
	if current_direction == "left" and linear_velocity.x > 0:
		sprite.texture = rightSprite
		current_direction = "right"
	if current_direction == "right" and linear_velocity.x < 0:
		sprite.texture = leftSprite
		current_direction = "left"
