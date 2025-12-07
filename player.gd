# player.gd
# Player-controlled character with jumping AND gravity flipping!
# Inherits movement, health, and physics from Character
extends Character

# === PLAYER CONSTANTS ===
const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# === GRAVITY FLIP TRACKING ===
# Track whether F key was pressed last frame (prevents multiple flips)
var _f_key_was_pressed: bool = false

# === INITIALIZATION ===
func _ready():
	# Call parent's initialization first
	super._ready()
	
	# Player-specific setup
	max_health = 3
	current_health = 3
	
	# ★ Register with GameManager
	GameManager.register_player(self)
	
	print("Player initialized:")
	print("  - Health: ", max_health, " hearts")
	print("  - Speed: ", SPEED)
	print("  - Jump Power: ", abs(JUMP_VELOCITY))
	print("  - Press F to flip gravity!")
	
	# ★ Initialize gravity UI
	_update_gravity_ui()

# === PLAYER PHYSICS ===
func _physics_process(delta):
	# --- GRAVITY FLIP INPUT ---
	# Check if F key is currently pressed
	var f_key_pressed = Input.is_key_pressed(KEY_F)
	
	# Only flip if F is pressed NOW but WASN'T pressed last frame
	# This means the player just pressed it (not holding)
	if f_key_pressed and not _f_key_was_pressed:
		_toggle_gravity()
	
	# Remember F key state for next frame
	_f_key_was_pressed = f_key_pressed
	
	# --- GRAVITY (from Character parent) ---
	apply_gravity(delta)
	
	# --- JUMP (player-specific) ---
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# ★ Jump direction automatically flips with gravity!
		# When gravity_multiplier = -1, jump becomes positive (downward jump)
		# When gravity_multiplier = 1, jump is negative (upward jump)
		velocity.y = JUMP_VELOCITY * gravity_multiplier
		print("🦘 Jump!")
	
	# --- MOVEMENT INPUT (player-specific) ---
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		# Update which way we're facing
		facing_direction = 1 if direction > 0 else -1
	else:
		# Slow down to stop
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# --- ANIMATION (player-specific) ---
	if has_node("AnimatedSprite2D"):
		if not is_on_floor():
			# In air
			if velocity.y < 0:
				$AnimatedSprite2D.play("jump")  # Going up
			else:
				$AnimatedSprite2D.play("fall")  # Going down
		elif direction != 0:
			# Walking
			$AnimatedSprite2D.play("walk")
		else:
			# Standing still
			$AnimatedSprite2D.play("idle")
	
	# Flip sprite to face movement direction
	update_facing_direction()
	
	# --- EXECUTE MOVEMENT (from Character parent) ---
	apply_movement()

# === GRAVITY FLIP FUNCTION ===
# Toggles gravity between normal (downward) and flipped (upward)
func _toggle_gravity() -> void:
	# Flip the multiplier: 1.0 becomes -1.0, -1.0 becomes 1.0
	gravity_multiplier *= -1
	
	# ★ Update the HUD indicator
	_update_gravity_ui()
	
	# ★ IMPORTANT: If player is on ground/ceiling, give them a push to get airborne!
	# Otherwise they'll be stuck to the platform
	
	if gravity_multiplier == -1.0:
		# Gravity just flipped to UPWARD
		print("🔄 GRAVITY FLIPPED! Player now falls UPWARD!")
		
		# If standing on floor, push them up to start upward fall
		if is_on_floor():
			velocity.y = -200.0  # Small upward velocity to "unstick" from floor
			print("   Pushed player off floor to start upward fall")
	
	else:
		# Gravity just flipped back to NORMAL (downward)
		print("🔄 GRAVITY NORMAL! Player now falls DOWNWARD!")
		
		# If stuck to ceiling, push them down to start downward fall
		if is_on_ceiling():
			velocity.y = 200.0  # Small downward velocity to "unstick" from ceiling
			print("   Pushed player off ceiling to start downward fall")

# === UPDATE GRAVITY UI ===
# Tells the HUD to update the gravity indicator
func _update_gravity_ui() -> void:
	# Find the HUD (it's a CanvasLayer, so it's accessible from anywhere)
	var hud = get_tree().get_first_node_in_group("hud")
	
	if hud and hud.has_method("update_gravity"):
		hud.update_gravity(gravity_multiplier)
	else:
		print("⚠️ WARNING: HUD not found or doesn't have update_gravity method")

# === CUSTOM DEATH BEHAVIOR ===
# Override parent's die() function
func die() -> void:
	print("💀 Player died!")
	
	# ★ Tell GameManager we died
	# GameManager will handle respawn or game over
	GameManager.on_player_death()
	
	# Note: We don't reload the scene here anymore!
	# GameManager handles that for us.
