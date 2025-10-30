# script for teleportation

extends Area2D

# === CONFIGURATION ===
# EXPORTED: You can change this in the Inspector for each teleporter!
# This is where the player will teleport to
@export var destination_position: Vector2 = Vector2(500, 300)

# How fast the fade animation plays (seconds)
@export var fade_duration: float = 0.5

# Is this teleporter currently active? (prevents double-teleport)
var is_active: bool = true

# === INITIALIZATION ===
func _ready():
	# Connect the collision detection signal
	# When a body enters this Area2D, call our function
	body_entered.connect(_on_body_entered)
	
	print("Teleporter ready at: ", global_position)
	print("Will teleport player to: ", destination_position)

# === COLLISION DETECTION ===
# This runs when ANY physics body touches the teleporter
func _on_body_entered(body):
	# Check if it's the player AND teleporter is active
	if "Player" in body.name and is_active:
		print("Player entered teleporter!")
		
		# Prevent multiple teleports while fading
		is_active = false
		
		# Start the teleportation sequence
		_teleport_player(body)

# === TELEPORTATION SEQUENCE ===
# Handles the fade out → move → fade in effect
func _teleport_player(player):
	print("Starting teleportation sequence...")
	
	# --- STEP 1: FADE OUT ---
	# Create a smooth animation (Tween) to fade player to invisible
	var fade_out = create_tween()
	# Animate the player's modulate.a (alpha/transparency) from 1.0 to 0.0
	fade_out.tween_property(player, "modulate:a", 0.0, fade_duration)
	
	# Wait for fade out to complete
	await fade_out.finished
	print("Fade out complete!")
	
	# --- STEP 2: TELEPORT (INSTANT MOVE) ---
	# Move player to the destination position
	player.global_position = destination_position
	print("Player teleported to: ", destination_position)
	
	# --- STEP 3: FADE IN ---
	# Create another Tween to fade player back to visible
	var fade_in = create_tween()
	# Animate from invisible (0.0) back to fully visible (1.0)
	fade_in.tween_property(player, "modulate:a", 1.0, fade_duration)
	
	# Wait for fade in to complete
	await fade_in.finished
	print("Fade in complete! Teleportation finished.")
	
	# Re-enable teleporter after a short delay (prevents accidental re-teleport)
	await get_tree().create_timer(0.5).timeout
	is_active = true
	print("Teleporter reactivated!")
