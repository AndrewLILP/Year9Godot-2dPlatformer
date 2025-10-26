extends Node2D

# === SCORE TRACKING ===
# This variable stores the player's current score
var score = 0

# === INITIALIZATION ===
func _ready():
	# Find ALL coin instances in this level
	var coins = get_tree().get_nodes_in_group("coins")
	
	# Connect to each coin's signal
	for coin in coins:
		coin.coin_collected.connect(_on_coin_collected)

# === COIN COLLECTION RESPONSE ===
# This function runs whenever ANY coin emits its signal
func _on_coin_collected():
	# Increase score by 1
	score += 1
	
	# Update the UI display
	$ScoreLabel.text = "Coins Collected: " + str(score)
	
	# Print to console for debugging
	print("Score: " + str(score))
