extends Node2D

@export var sceneLocation: String = "res://Scenes/level_1.tscn"

var parentPlayer: Node2D
var player: CharacterBody2D
var playerCamera: Camera2D
var canRestart = true
var map: Camera2D 

@onready var finish_camera: Camera2D = $Goal/End_Point
@onready var pauseMenu: Control = $Menus/PauseMenu
@onready var settingsMenu: Control = $Menus/SettingsMenu
@onready var winScreen: Control = $Menus/WinScreen
@onready var blurb: PackedScene = preload("res://Scenes/Players/Blurb.tscn")
@onready var boblina: PackedScene = preload("res://Scenes/Players/Boblina.tscn")

var current_view: String
var camera_change_cooldown: float = 1
var player_script: Script

func restartLevel() -> void:
	if !canRestart:
		return
	
	resetCollectables()
	
	if CameraTransition.transitioning:
		CameraTransition.tween.kill()
		CameraTransition.transitioning = false
	get_tree().reload_current_scene()

func _input(_event: InputEvent) -> void:
	if !canRestart: return
	
	if Input.is_action_just_pressed("Reset"):
		player.respawn() 
	
	if Input.is_action_just_pressed("Pause"):
		handlePauseMenu()
	
	if Input.is_action_just_pressed("Escape"):
		handleEscape()
		
	
	if camera_change_cooldown >= 0 or CameraTransition.transitioning or isPaused():
		return
	
	if Input.is_action_just_pressed("Map"):
		handleMap()

func handleEscape() -> void:
	if isPaused():
		handlePauseMenu()

func handleMap() -> void:
	CameraTransition.transition_type = Tween.TRANS_QUAD
	CameraTransition.transition_ease = Tween.EASE_IN_OUT
	
	if current_view == "player":
		player.set_meta("canMove", false)
		
		map = player.map
		
		CameraTransition.transition_camera(map, playerCamera, 1)
	elif current_view == "map":
		CameraTransition.transition_camera(playerCamera, map, 1)

func handlePauseMenu() -> void:
	if winScreen.isOpen():
		return
		
	if isPaused():
		pauseMenu.closeMenu()
		settingsMenu.closeMenu()
		player.set_meta("canMove", true)
	else:
		pauseMenu.openMenu()
		player.set_meta("canMove", false)
	
	if CameraTransition.transitioning or current_view == "map":
		player.set_meta("canMove", false)

func handleSettingsMenu() -> void:
	if settingsMenu.isOpen():
		settingsMenu.closeMenu()
		pauseMenu.openMenu()
	else:
		settingsMenu.openMenu()
		pauseMenu.closeMenu()

func isPaused() -> bool:
	return pauseMenu.isOpen() or settingsMenu.isOpen() or winScreen.isOpen()

func _process(delta: float) -> void:
	camera_change_cooldown -= delta

func handleTransitionFinish() -> void:
	if current_view == "player":
		current_view = "map"
		player.current_view = "map"
	else:
		current_view = "player"
		player.current_view = "player"
		player.set_meta("canMove", true)
	
	if isPaused():
		player.set_meta("canMove", false)

func _ready() -> void:
	var transitionFinish = Callable(self, "handleTransitionFinish")
	
	CameraTransition.connect("finished", transitionFinish)
	
	setActivePlayer()
	resetCollectables()
	
	playerCamera.enabled = true
	finish_camera.enabled = true
	
	#playerCamera.make_current()
	CameraTransition.transition_camera(playerCamera, finish_camera, 3)

func setActivePlayer() -> void:
	if GameData.current_player == "Blurb":
		var Blurb = blurb.instantiate()
		add_child(Blurb)
		player = Blurb.get_child(0)
		playerCamera = player.get_child(-1)
		$Goal.player = player
	else:
		var Boblina = boblina.instantiate()
		add_child(Boblina)
		player = Boblina.get_child(0)
		playerCamera = player.get_child(-1)
		$Goal.player = player

func changeToNextScene():
	var nextScene: String = get_meta("nextScene")
	
	resetCollectables()
	
	get_tree().change_scene_to_file(nextScene)

func resetCollectables() -> void:
	GameData.resetCollectableCount()

func resetEnemiesKilled() -> void:
	GameData.resetEnemiesKilled()

func resetKeys() -> void:
	GameData.resetKeys()

func resetCoins() -> void:
	GameData.resetCurrentCoins()
