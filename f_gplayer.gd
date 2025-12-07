extends CharacterBody2D

# ============================================================================
# PLAYER CONTROLLER SCRIPT
# ============================================================================
# This script controls player movement, jumping, and gravity flipping
# Completed through: Lessons 1-2 + Side Quest 2 (Gravity Flip)
# ============================================================================

# === MOVEMENT CONSTANTS ===
# These values never change during gameplay (const = constant)
const SPEED = 300.0              # How fast the player moves left/right (pixels per second)
const JUMP_VELOCITY = -400.0     # How strong the jump is (negative = upward)

# === GRAVITY FLIP SYSTEM ===
# Variables for the gravity flip mechanic (press F to flip)

# Multiplier for gravity direction: 1.0 = normal (down), -1.0 = flipped (up)
var gravity_multiplier: float = 1.0

# Track whether gravity is currently flipped (true = walking on ceiling)
var gravity_flipped: bool = false

# Cooldown timer to prevent rapid gravity switching (counts down to 0)
var flip_cooldown: float = 0.0

# How long to wait between flips in seconds (prevents spamming F key)
const FLIP_COOLDOWN_TIME: float = 0.5

# Target rotation angle for smooth sprite rotation (0° = normal, 180° = upside down)
var target_rotation: float = 0.0

# How quickly sprite rotates to target angle (higher = faster, lower = slower)
const ROTATION_SPEED: float = 10.0


# === INITIALIZATION ===
# Called once when the player is first created in the level
func _ready():
	# Find the goal box in the level and connect to its signal
	var goal_box = get_parent().get_node("GoalBox")
	goal_box.body_entered.connect(_on_goal_box_body_entered)
	
	print("=== PLAYER READY ===")
	print("Controls: Arrow keys = Move, Spacebar = Jump, F = Flip Gravity")


# === MAIN PHYSICS FUNCTION ===
# Called every frame (60 times per second)
# delta = time since last frame (usually 0.016 seconds at 60 FPS)
func _physics_process(delta):
	
	# --- COUNTDOWN COOLDOWN TIMER ---
	# Decrease the cooldown timer each frame until it reaches 0
	if flip_cooldown > 0:
		flip_cooldown -= delta
	
	# --- GRAVITY FLIP INPUT ---
	# Check if player presses F key (ui_focus_next) and cooldown has finished
	if Input.is_action_just_pressed("ui_focus_next") and flip_cooldown <= 0:
		_flip_gravity()  # Call the gravity flip function
	
	# --- APPLY GRAVITY (WITH MULTIPLIER) ---
	# Only apply gravity when player is in the air (not touching ground)
	if not is_on_floor():
		# get_gravity() returns downward gravity force
		# Multiply by gravity_multiplier (1.0 or -1.0) to control direction
		# Multiply by delta to make it frame-rate independent
		velocity += get_gravity() * gravity_multiplier * delta
	
	# --- JUMP CODE ---
	# Check if spacebar pressed AND player is on the ground
	# is_action_just_pressed = only true on the FIRST frame of press (not held)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# Set upward velocity (negative Y = up in Godot's coordinate system)
		velocity.y = JUMP_VELOCITY
		print("Jump!")
	
	# --- GET PLAYER INPUT ---
	# get_axis returns: -1 (left pressed), 0 (neither), or +1 (right pressed)
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# --- MOVE THE PLAYER ---
	if direction:
		# If left or right is pressed, set horizontal velocity
		velocity.x = direction * SPEED
	else:
		# If no input, gradually slow down to a stop
		# move_toward smoothly transitions from current velocity to 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# --- ANIMATION CONTROL ---
	# This section only exists if you completed Game Art Lessons 1-2
	# If you only have a ColorRect or Sprite2D, this code won't run (and that's fine!)
	if has_node("AnimatedSprite2D"):
		if direction != 0:
			# Player is moving - play walk animation
			$AnimatedSprite2D.play("walk")
			# Flip sprite horizontally when moving left (direction < 0)
			$AnimatedSprite2D.flip_h = (direction < 0)
		else:
			# Player is standing still - play idle animation
			$AnimatedSprite2D.play("idle")
	
	# --- SMOOTH ROTATION ---
	# Gradually rotate the entire Player node toward target angle
	# lerp = Linear intERPolation (smooth transition between two values)
	# This rotates player 0° when normal, 180° when gravity is flipped
	rotation_degrees = lerp(rotation_degrees, target_rotation, ROTATION_SPEED * delta)
	
	# --- EXECUTE THE MOVEMENT ---
	# Actually move the player based on velocity and handle collisions
	move_and_slide()


# === GRAVITY FLIP FUNCTION ===
# Called when player presses F to flip gravity direction
func _flip_gravity():
	# Toggle the flipped state (! means "opposite of")
	# If gravity_flipped is false, it becomes true (and vice versa)
	gravity_flipped = !gravity_flipped
	
	# Flip the gravity multiplier
	# If it's 1.0, multiply by -1 to get -1.0
	# If it's -1.0, multiply by -1 to get 1.0
	gravity_multiplier *= -1.0
	
	# Print debug information to the Output panel
	print("🔄 GRAVITY FLIPPED!")
	
	if gravity_flipped:
		print("  → Ceiling mode activated (gravity pulls UP)")
		print("  → Player will walk on ceiling")
		target_rotation = 180.0  # Set target to upside down
	else:
		print("  → Floor mode activated (gravity pulls DOWN)")
		print("  → Player will walk on floor")
		target_rotation = 0.0    # Set target to right-side up
	
	# IMPORTANT: Velocity is preserved automatically!
	# If player was jumping up (negative Y velocity), they continue moving up
	# But now gravity will pull them back toward the CEILING instead of floor
	# This creates the "momentum preservation" effect
	
	# Trigger visual feedback effects
	_trigger_screen_shake()    # Make camera shake briefly
	_update_gravity_indicator() # Update UI label
	
	# Start the cooldown timer
	# Player must wait FLIP_COOLDOWN_TIME seconds before flipping again
	flip_cooldown = FLIP_COOLDOWN_TIME
	print("  ⏱️ Cooldown: ", FLIP_COOLDOWN_TIME, " seconds")


# === SCREEN SHAKE EFFECT ===
# Creates a brief camera shake for visual feedback when gravity flips
func _trigger_screen_shake():
	# Try to find the Camera2D in the level
	var camera = get_viewport().get_camera_2d()
	
	# If no camera exists, skip the shake (fail silently)
	if camera == null:
		return
	
	# Create a Tween for smooth animation
	# Tweens animate properties over time
	var shake_tween = create_tween()
	
	# How many pixels to shake the camera
	var shake_strength = 5.0
	
	# How long the shake lasts (in seconds)
	var shake_duration = 0.15
	
	# Shake sequence: left → right → center
	# Each movement takes 1/3 of the total duration
	
	# Move camera 5 pixels to the right
	shake_tween.tween_property(camera, "offset:x", shake_strength, shake_duration / 3)
	
	# Move camera 5 pixels to the left (10 pixel swing total)
	shake_tween.tween_property(camera, "offset:x", -shake_strength, shake_duration / 3)
	
	# Return camera to center position (0 offset)
	shake_tween.tween_property(camera, "offset:x", 0, shake_duration / 3)


# === UPDATE GRAVITY INDICATOR ===
# Updates the UI label showing current gravity direction
func _update_gravity_indicator():
	# Try to find the GravityIndicator label in the level
	# We create this UI element in Part 2 of the lesson
	if has_node("/root/Node2D/GravityIndicator"):
		# Get reference to the label
		var indicator = get_node("/root/Node2D/GravityIndicator")
		
		if gravity_flipped:
			# Ceiling mode - show upward arrow and make it red
			indicator.text = "↑ CEILING MODE"
			indicator.modulate = Color(1.0, 0.3, 0.3)  # Red tint
		else:
			# Floor mode - show downward arrow and make it green
			indicator.text = "↓ FLOOR MODE"
			indicator.modulate = Color(0.3, 1.0, 0.3)  # Green tint


# === GOAL COLLISION RESPONSE ===
# Called when player enters the GoalBox area
func _on_goal_box_body_entered(body):
	# Check if the body that entered is this player
	if body == self:
		print("Level Complete! Great job!")
		# Change to the victory scene (level_2.tscn)
		get_tree().change_scene_to_file("res://level_2.tscn")


# ============================================================================
# END OF PLAYER SCRIPT
# ============================================================================
# Features implemented:
# ✅ Left/right movement with arrow keys
# ✅ Jumping with spacebar
# ✅ Gravity application
# ✅ Animation control (if AnimatedSprite2D exists)
# ✅ Goal detection and level transition
# ✅ Gravity flipping with F key
# ✅ Cooldown timer system
# ✅ Smooth rotation (0° normal, 180° flipped)
# ✅ Screen shake effect
# ✅ UI indicator updates
# ✅ Momentum preservation through gravity flip
# ============================================================================
