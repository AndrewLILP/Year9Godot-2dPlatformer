# player.gd
# Player-controlled character with jumping
# Inherits movement, health, and physics from Character
extends Character

# === PLAYER CONSTANTS ===
const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# === GRAVITY MULTIPLIER ===
# Allows external scripts (like gravity button) to flip gravity direction
# 1.0 = normal downward gravity
# -1.0 = flipped upward gravity
# This variable is modified by the GravityButton script
#var gravity_multiplier: float = 1.0

# === INITIALIZATION ===
func _ready():
	# Call parent's initialization first
	super._ready()
	
	# Player-specific setup
	max_health = 3
	current_health = 3
	
	# ★ NEW: Register with GameManager
	GameManager.register_player(self)
	
	print("Player initialized:")
	print("  - Health: ", max_health, " hearts")
	print("  - Speed: ", SPEED)
	print("  - Jump Power: ", abs(JUMP_VELOCITY))
	
	# === REMOVED: Goal detection (GoalBox handles this now!)
	# OLD CODE - DELETE THIS IF YOU HAVE IT:
	# if get_parent().has_node("GoalBox"):
	#     var goal_box = get_parent().get_node("GoalBox")
	#     goal_box.body_entered.connect(_on_goal_box_body_entered)

# === PLAYER PHYSICS ===
func _physics_process(delta):
	# --- GRAVITY (from Character parent) ---
	apply_gravity(delta)
	
	# --- ★ JUMP (player-specific) ---
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
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

# === REMOVED: Goal detection function
# OLD CODE - DELETE THIS IF YOU HAVE IT:
# func _on_goal_box_body_entered(body):
#     if body == self:
#         print("Level Complete!")
#         get_tree().change_scene_to_file("res://level_2.tscn")

# === ★ NEW: Custom Death Behavior ===
# Override parent's die() function
func die() -> void:
	print("💀 Player died!")
	
	# ★ Tell GameManager we died
	# GameManager will handle respawn or game over
	GameManager.on_player_death()
	
	# Note: We don't reload the scene here anymore!
	# GameManager handles that for us.
