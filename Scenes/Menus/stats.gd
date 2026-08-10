extends Label

func _ready() -> void:
	text = "Coins Collected: \t %d \n Deaths: \t %d" % [GameData.getTotalCoins(), GameData.deaths]
