# enemy.gd

extends CharacterBody2D

# === MOVEMENT CONSTANTS ===
# How fast the enemy moves (pixels per second)
const SPEED = 100.0

# === MOVEMENT VARIABLES ===
# Current direction: 1 = moving right, -1 = moving left
var direction = 1

# Timer to track when to turn around
var move_timer = 0.0

# How long to move in each direction (in seconds)
const MOVE_TIME = 2.0

# === INITIALIZATION ===
# Called once when enemy is created
func _ready():
	print("=== ENEMY SPAWNED ===")
	
	# Connect HitBox signal if it exists
	if has_node("HitBox"):
		print("✓ HitBox found and connected!")
		# Connect the signal to detect player collision
		$HitBox.body_entered.connect(_on_hit_box_body_entered)
	else:
		print("✗ ERROR: HitBox not found!")

# === MAIN PHYSICS FUNCTION ===
# Called every frame (delta = time since last frame)
func _physics_process(delta):
	# --- APPLY GRAVITY ---
	# Make enemy fall if not on ground
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# --- MOVE IN CURRENT DIRECTION ---
	# Multiply direction (1 or -1) by SPEED to get velocity
	velocity.x = direction * SPEED
	
	# --- COUNT UP THE TIMER ---
	# Add elapsed time to the timer
	move_timer += delta
	
	# --- CHECK IF TIME TO TURN AROUND ---
	if move_timer >= MOVE_TIME:
		# Time's up! Reverse direction
		direction *= -1  # Flip: 1 becomes -1, -1 becomes 1
		move_timer = 0.0  # Reset timer back to zero
		print("Enemy turned! Now moving: ", "RIGHT" if direction == 1 else "LEFT")
	
	# --- EXECUTE THE MOVEMENT ---
	# Actually move the enemy based on velocity
	move_and_slide()

# === PLAYER COLLISION ===
# Called when something enters the HitBox
func _on_hit_box_body_entered(body):
	print("Something hit the enemy: ", body.name)
	
	# Check if "Player" is anywhere in the body's name
	# This works for: Player, Player2, PlayerL2, etc.
	if "Player" in body.name:
		print("💀 Player hit enemy! Restarting level...")
		# Use call_deferred to safely reload after physics finishes
		get_tree().call_deferred("reload_current_scene")
