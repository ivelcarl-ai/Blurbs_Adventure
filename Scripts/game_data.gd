extends Node2D

var current_player: String = "Blurb"
var current_coins: int = 0
var total_coins: int = 0
var deaths: int = 0
var number_of_keys: int = 0
var enemiesKilled : int = 0
var totalEnemiesKilled: int = 0
var audioOn: bool = true
var lobbyAudioPosition: float = 0.0

func setLobbyAudioPosition(audioPosition: float) -> void:
	lobbyAudioPosition = audioPosition

func getLobbyAudioPosition() -> float:
	return lobbyAudioPosition

func addCoin() -> void:
	current_coins += 1
	total_coins += 1

func getCurrentCoins() -> int:
	return current_coins

func getTotalCoins() -> int:
	return total_coins

func resetCurrentCoins() -> void:
	current_coins = 0

func has_key() -> bool:
	if number_of_keys > 0:
		return true
	return false

func use_key() -> void:
	if number_of_keys > 0:
		number_of_keys -= 1

func collect_key() -> void:
	number_of_keys += 1

func get_keys() -> int:
	return number_of_keys

func resetKeys() -> void:
	number_of_keys = 0

func getEnemiesKilled() -> int:
	return enemiesKilled

func killEnemy() -> void:
	enemiesKilled += 1
	totalEnemiesKilled += 1

func resetEnemiesKilled() -> void:
	enemiesKilled = 0

func changeAudio() -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	if audioOn:
		audioOn = false
		AudioServer.set_bus_mute(bus_idx, true)
	else:
		audioOn = true
		AudioServer.set_bus_mute(bus_idx, false)

func resetCollectableCount() -> void:
	resetKeys()
	resetCurrentCoins()
	resetEnemiesKilled()
