# enemy.gd
# AI-controlled enemy that patrols and damages player
# Inherits movement, health, and physics from Character
extends Character

# === ENEMY CONSTANTS ===
const SPEED = 100.0
const MOVE_TIME = 2.0  # Seconds before turning around

# === PATROL VARIABLES ===
var move_timer = 0.0

# === INITIALIZATION ===
func _ready():
	# Call parent initialization
	super._ready()
	
	# Enemy-specific setup
	max_health = 1
	current_health = 1
	
	# Connect HitBox for player detection
	if has_node("HitBox"):
		$HitBox.body_entered.connect(_on_hit_box_body_entered)
		print(name, " HitBox connected")
	else:
		print("WARNING: ", name, " has no HitBox!")

# === ENEMY AI ===
func _physics_process(delta):
	# --- GRAVITY (from parent) ---
	apply_gravity(delta)
	
	# --- PATROL MOVEMENT (enemy-specific) ---
	velocity.x = facing_direction * SPEED
	
	# Count up timer
	move_timer += delta
	
	# Turn around when timer expires
	if move_timer >= MOVE_TIME:
		facing_direction *= -1  # Reverse: 1 becomes -1, -1 becomes 1
		move_timer = 0.0  # Reset timer
		print(name, " turned around!")
	
	# --- ANIMATION (enemy-specific) ---
	if has_node("AnimatedSprite2D"):
		if abs(velocity.x) > 10:
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
	
	# Flip sprite to face movement direction
	update_facing_direction()
	
	# --- EXECUTE MOVEMENT (from parent) ---
	apply_movement()

# === PLAYER COLLISION ===
func _on_hit_box_body_entered(body):
	print(name, " detected collision with: ", body.name)
	
	# Check if it's the player
	if "Player" in body.name:
		print("Player hit enemy!")
		
		# Damage the player using inherited take_damage function
		if body.has_method("take_damage"):
			body.take_damage(1)
		else:
			# Fallback: Restart level if no health system
			print("Player has no take_damage method, restarting level")
			get_tree().call_deferred("reload_current_scene")

# === CUSTOM DEATH BEHAVIOR ===
# Override parent's die() function
func die() -> void:
	print(name, " was defeated!")
	# TODO: Later add coin drops, particles, etc.
	queue_free()
