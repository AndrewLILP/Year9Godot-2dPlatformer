extends Area2D

# Signal that tells level "player scored!"
signal scored

# Has this zone been used?
var has_scored = false

func _ready():
	# Connect collision detection
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# When player enters zone
func _on_body_entered(body):
	if not has_scored and "BirdPlayer" in body.name:
		print("SCORE!")
		has_scored = true
		scored.emit()

# When player exits zone (reset for recycling)
func _on_body_exited(body):
	if "BirdPlayer" in body.name:
		has_scored = false
