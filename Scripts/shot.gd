extends Node2D

var initial_velocity: Vector2 = Vector2(0, 0)
var player: CharacterBody2D
var timeAlive: float = 0
var timePenalty: float = 0
var notPlaying = true


@onready var my_body: RigidBody2D = $RigidBody2D
@onready var sprite: Sprite2D = $RigidBody2D/BoxShot
@onready var level: Node2D = $".."
@onready var currentPlayer: String = GameData.current_player

@export var speed: int = 80
@export var returnSound: AudioStreamPlayer2D

func _ready() -> void:
	if currentPlayer == "Boblina":
		setUpBoblina()
	elif currentPlayer == "Blurb":
		setUpBlurb()
	
	initializeShot()
	
	timePenalty = player.getTimeSinceGrounded()

func initializeShot() -> void:
	initial_velocity = -(player.velocity.normalized()) * 500 
	my_body.linear_velocity = initial_velocity
	my_body.global_position = player.global_position + 0.05 * initial_velocity
	my_body.contact_monitor = true
	my_body.max_contacts_reported = 100

func setUpBoblina() -> void:
	player = $"../Boblina/CharacterBody2D"
	sprite.texture = load("res://Art/Sprites/Boblina/BoblinaShot.png")

func setUpBlurb() -> void:
	player = $"../Blurb/CharacterBody2D"
	sprite.texture = load("res://Art/Sprites/Blurb/BoxShot.png")

func get_player_direction() -> Vector2:
	return (player.global_position - my_body.global_position).normalized()

func isPaused():
	return !player.get_meta("canMove")

func _physics_process(delta: float) -> void:
	if isPaused():
		my_body.freeze = true
		return

	my_body.freeze = false
	
	
	
	if timePenalty < 3:
		handleDefaultMovement(delta)
	else:
		handlePenalizedMovement(delta)
	
	timeAlive += delta
	

func handleDefaultMovement(delta) -> void:
	var direction = get_player_direction()
	
	if timeAlive < 0.7:
		my_body.apply_force(direction * speed * delta * 20)
	else:
		my_body.linear_velocity = Vector2(direction * speed * 1.8)
		if isNearPlayer() and notPlaying:
			notPlaying = false
			returnSound.play()

func isNearPlayer() -> bool:
	return (player.global_position - my_body.global_position).length() < 250

func handlePenalizedMovement(delta) -> void:
	var direction = get_player_direction()
	
	if timeAlive < timePenalty:
		my_body.apply_force(direction * speed * delta * 10)
	else:
		my_body.linear_velocity = Vector2(direction * speed * 1.6)

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body.has_meta("Role"):
		body.regrow()
		queue_free()
