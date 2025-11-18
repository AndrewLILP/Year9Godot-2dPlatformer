# coin.gd - UPDATE THIS
extends Area2D

# How many points this coin is worth
@export var point_value: int = 1

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if "Player" in body.name:
		# ★ NEW: Add score to GameManager (persists between levels!)
		GameManager.add_score(point_value)
		
		print("💰 Coin collected! +", point_value, " points")
		
		# Remove coin
		queue_free()
