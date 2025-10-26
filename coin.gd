extends Area2D

# === SIGNAL DEFINITION ===
# This signal announces "A coin was collected!"
# Other scripts can listen for this event
signal coin_collected

# === INITIALIZATION ===
func _ready():
	# Connect our collision detection to our response function
	# When something enters our area, call _on_body_entered
	body_entered.connect(_on_body_entered)

# === COLLISION DETECTION ===
# This function runs when ANY body touches the coin
func _on_body_entered(body):
	# Check if the body that touched us is named "Player"
	if body.name == "Player":
		# Announce that this coin was collected
		coin_collected.emit()
		
		# Delete this coin from the game
		queue_free()
