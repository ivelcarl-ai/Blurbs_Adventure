extends CharacterBody2D

@export var speed: int = 100
@export var jumpSpeed: int = 250
@export var current_size: int = 5
@export var grounded_countdown: float = 0.2
@export var max_jump_buffer: float = 0.2
@export var acceleration: float = 0.1
@export var deceleration: float = 0.4
@export var regrowth_time: float = 1
@export var can_move: bool = true
@export var current_view: String = "player"
@export var coinSound: AudioStreamPlayer2D
@export var keyCollect: AudioStreamPlayer2D
@export var gateUnlock: AudioStreamPlayer2D
@export var playerDeath: AudioStreamPlayer2D

var testScript: GDScript = load("res://Scripts/level.gd")
var sidewaysParticles: GPUParticles2D
var jumpParticles1: GPUParticles2D
var jumpParticles2: GPUParticles2D
var jumpParticles3: GPUParticles2D
var currentJumpParticles: GPUParticles2D
var coins: int = 0
var last_checkpoint: Area2D
var map: Camera2D
var timeSinceGrounded = 0
var gravityCooldown: float = 0

@onready var box_shot = preload("res://Scenes/Players/shot.tscn")
@export var size_5_right: CompressedTexture2D
@export var size_4_right: CompressedTexture2D
@export var size_3_right: CompressedTexture2D
@export var size_2_right: CompressedTexture2D
@export var size_1_right: CompressedTexture2D
@export var size_5_left: CompressedTexture2D
@export var size_4_left: CompressedTexture2D
@export var size_3_left: CompressedTexture2D
@export var size_2_left: CompressedTexture2D
@export var size_1_left: CompressedTexture2D
#@onready var maxSize: int = get_parent().get_script().maxSize

var is_grounded: bool = false
var can_dash: bool = true
var jump_buffer: float = 0
var till_regrow
var direction

func _ready() -> void:
	var level: Node2D = get_parent().get_parent()
	sidewaysParticles = $SidewaysParticles
	jumpParticles1 = $JumpParticles1
	jumpParticles2 = $JumpParticles2
	jumpParticles3 = $JumpParticles3
	currentJumpParticles = jumpParticles1
	
	
	current_size = level.get_meta("maxSize")
	update_size()

func _pause_movement() -> void:
	can_move = false

func _resume_movement() -> void:
	can_move = true

func update_sprite_left() -> void:
	if current_size == 5:
		$character_sprite.texture = size_5_left
	if current_size == 4:
		$character_sprite.texture = size_4_left
	if current_size == 3:
		$character_sprite.texture = size_3_left
	if current_size == 2:
		$character_sprite.texture = size_2_left
	if current_size == 1:
		$character_sprite.texture = size_1_left
	
func update_sprite_right() -> void:
	if current_size == 5:
		$character_sprite.texture = size_5_right
	if current_size == 4:
		$character_sprite.texture = size_4_right
	if current_size == 3:
		$character_sprite.texture = size_3_right
	if current_size == 2:
		$character_sprite.texture = size_2_right
	if current_size == 1:
		$character_sprite.texture = size_1_right

func update_size():
	till_regrow = regrowth_time 
	
	if current_size == 5:
		$CollisionShape2D.shape.size = Vector2(16, 16)
	elif current_size == 4:
		$CollisionShape2D.shape.size = Vector2(14, 14)
	elif current_size == 3:
		$CollisionShape2D.shape.size = Vector2(12, 12)
	elif current_size == 2:
		$CollisionShape2D.shape.size = Vector2(10, 10)
		can_dash = true
	elif current_size == 1:
		$CollisionShape2D.shape.size = Vector2(8, 8)
		can_dash = false
	
	if direction == "left":
		update_sprite_left()
	else:
		update_sprite_right()

func get_current_direction() -> Vector2:
	var verticle: int = 0
	var horizontal: int = 0
	
	if Input.is_action_pressed("Up"):
		verticle -= 1
	if Input.is_action_pressed("Down"):
		verticle += 1
	if Input.is_action_pressed("Left"):
		horizontal -= 1
	if Input.is_action_pressed("Right"):
		horizontal += 1
	
	var returnDirection: Vector2 = Vector2(horizontal, verticle).normalized()
	return returnDirection

func apply_gravity(delta) -> void:
	if gravityCooldown > 0:
		gravityCooldown -= delta
		return
	
	if is_on_floor():
		is_grounded = true
		grounded_countdown = 0.1
		timeSinceGrounded = 0
	else:
		grounded_countdown -= delta
		timeSinceGrounded += delta
	
	if grounded_countdown <= 0:
		is_grounded = false
	
	if velocity.y >= 0:
		velocity.y += 40
	else:
		velocity.y += 15

func apply_drag() -> void:
	if velocity.x > speed or velocity.x < -speed:
		velocity.x -= velocity.x * (0.1)
	if velocity.y > jumpSpeed or velocity.y < -jumpSpeed:
		velocity.y -= velocity.y * (0.1)

func jump() -> void:
	velocity = Vector2(velocity.x, -1 * speed * 2.5)
	current_size -= 1
	update_size()
	
	var shot_node = box_shot.instantiate()
	get_parent().get_parent().add_child(shot_node)
	
	handleJumpParticles()
	
func move_left() -> void:
	if velocity.x < -speed:
		pass
	elif velocity.x > speed:
		velocity.x -= (speed * deceleration)
	else:
		velocity.x -= (speed * acceleration)
		update_sprite_left()
	
	sidewaysParticles.position.y = (current_size - 1 + 4)
	sidewaysParticles.position.x = (current_size - 1 + 4)
	direction = "left"

func move_right() -> void:
	if velocity.x < -speed:
		velocity.x += speed * deceleration
	elif velocity.x > speed:
		pass
	else:
		velocity.x += speed * acceleration
		update_sprite_right()
	sidewaysParticles.position.x = -(current_size - 1 + 4)
	sidewaysParticles.position.y = (current_size - 1 + 4)
	direction = "right"

func dash() -> void:
	if direction == "left":
		velocity = Vector2(-5 * speed, 0)
	else:
		velocity = Vector2(5 * speed, 0)
	current_size -= 1
	update_size()
	
	position.y -= 1
	
	var shot_node = box_shot.instantiate()
	get_parent().get_parent().add_child(shot_node)
	
	gravityCooldown = 0.2
	
	handleJumpParticles()

func handleJumpParticles() -> void:
	if currentJumpParticles == jumpParticles1:
		currentJumpParticles = jumpParticles2
	elif currentJumpParticles == jumpParticles2:
		currentJumpParticles = jumpParticles3
	else:
		currentJumpParticles = jumpParticles1
	
	currentJumpParticles.position.y = (current_size - 2 + 4)
	currentJumpParticles.restart()

func regrow() -> void:
	current_size += 1
	update_size()

func handleVerticleMovement(delta) -> void:
	apply_gravity(delta)
	apply_drag()
	
	if Input.is_action_just_pressed("Up") and can_dash:
		jump()
		is_grounded = false

func handleHorizontalMovement() -> void:
	if Input.is_action_pressed("Left"):
		move_left()
	elif Input.is_action_pressed("Right"):
		move_right()
	else:
		if gravityCooldown > 0: return
		velocity.x -= (velocity.x * 0.3)

func updateCanMove() -> void:
	if CameraTransition.transitioning:
		set_meta("canMove", false)
	can_move = get_meta("canMove")

func _physics_process(delta):
	updateCanMove()
	
	if !can_move: return
	
	handleVerticleMovement(delta)
	handleHorizontalMovement()
	
	if Input.is_action_just_pressed("Action") and can_dash:
		dash()
	
	move_and_slide()
	
	if velocity.length() > speed / 10.0 and is_grounded:
		sidewaysParticles.emitting = true
	else:
		sidewaysParticles.emitting = false
	
	check_respawn()

func check_respawn() -> void:
	if position.y > 500:
		respawn()

func respawn() -> void:
	var level = get_parent().get_parent()
	current_size = level.get_meta("maxSize")
	update_size()
	can_dash = true
	
	playSound("playerDeath")
	GameData.deaths += 1
	
	global_position = last_checkpoint.global_position
	
	for child in level.get_children():
		if !child.has_meta("Role"): print(child.get_index())
		
		if child.get_meta("Role") == "Shot":
			child.queue_free()

func addCoin() -> void:
	coins += 1 

func getCoins() -> int:
	return coins

func set_last_checkpoint(checkpoint: Area2D) -> void:
	if last_checkpoint != null:
		last_checkpoint.get_child(0).enabled = false
	
	last_checkpoint = checkpoint
	
	map = last_checkpoint.get_child(0)

func getTimeSinceGrounded() -> float:
	return timeSinceGrounded

func playSound(sound: String) -> void:
	if sound == "coin":
		coinSound.play()
	elif sound == "keyCollected":
		keyCollect.play()
	elif sound == "gateUnlocked":
		gateUnlock.play()
	elif sound == "playerDeath":
		playerDeath.play()
