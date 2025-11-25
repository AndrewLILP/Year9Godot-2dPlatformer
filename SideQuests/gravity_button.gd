extends Area2D

# ============================================================================
# GRAVITY FLIP BUTTON SCRIPT
# ============================================================================
# This button toggles the player's gravity between normal and flipped
# When activated, player falls UPWARD and can walk on the ceiling!
# ============================================================================

# === PLAYER REFERENCE ===
# We'll find the player automatically using groups
var player: CharacterBody2D = null


# === GRAVITY STATE ===
# Tracks whether gravity is currently normal or flipped
var gravity_flipped: bool = false


# === VISUAL REFERENCES ===
# Cache references to child nodes for quick access
@onready var button_visual = $ColorRect
@onready var label = $Label


# === COLOR CONSTANTS ===
# Visual feedback colors for button state
const COLOR_NORMAL = Color(0, 1, 0)    # Green = normal gravity (down)
const COLOR_FLIPPED = Color(1, 0, 0)   # Red = flipped gravity (up)


# === INITIALIZATION ===
# Called once when the button is created
func _ready():
	print("=== GRAVITY BUTTON INITIALIZED ===")
	
	# Connect the collision detection signal
	# When a physics body enters our Area2D, call _on_body_entered
	body_entered.connect(_on_body_entered)
	print("✓ Collision signal connected")
	
	# Find the player node automatically using groups
	# This searches the entire scene tree for a node in the "player" group
	player = get_tree().get_first_node_in_group("player")
	
	# Verify we found the player
	if player == null:
		print("⚠️ WARNING: Player not found!")
		print("SOLUTION: Select Player node → Node tab → Groups → Add 'player'")
		print("The button won't work until player is in the 'player' group!")
	else:
		print("✓ Player found: ", player.name)
		
		# Check if player has the gravity_multiplier variable
		if "gravity_multiplier" in player:
			print("✓ Player has gravity_multiplier variable - ready to flip!")
		else:
			print("⚠️ WARNING: Player missing 'gravity_multiplier' variable!")
			print("SOLUTION: Add 'var gravity_multiplier: float = 1.0' to player.gd")
	
	# Set initial button appearance (green with down arrow)
	_update_button_appearance()
	print("✓ Initial appearance set (green = normal gravity)")


# === COLLISION DETECTION ===
# Called when ANY physics body touches the button
func _on_body_entered(body):
	print("Something touched gravity button: ", body.name)
	
	# Check if it's the player
	if body == player or "Player" in body.name:
		print("✅ Player activated gravity button!")
		_toggle_gravity()
	else:
		print("Not the player - ignoring")


# === GRAVITY TOGGLE LOGIC ===
# Switches gravity between normal and flipped states
func _toggle_gravity():
	# Safety check: make sure we have a valid player reference
	if player == null:
		print("❌ Cannot flip gravity - player not found!")
		return
	
	# Flip the state
	gravity_flipped = !gravity_flipped  # ! means "opposite of"
	
	# Apply the appropriate gravity based on new state
	if gravity_flipped:
		print("🔄 GRAVITY FLIPPED → Player now falls UPWARD!")
		_apply_flipped_gravity()
	else:
		print("🔄 GRAVITY NORMAL → Player now falls DOWNWARD!")
		_apply_normal_gravity()
	
	# Update the button's visual appearance
	_update_button_appearance()


# === APPLY FLIPPED GRAVITY ===
# Makes the player fall UPWARD instead of downward
func _apply_flipped_gravity():
	# Method 1: gravity_scale property (Godot 4.3+)
	# This is built into CharacterBody2D in newer Godot versions
	if "gravity_scale" in player:
		player.gravity_scale = -1.0  # Negative = upward gravity
		print("  ✓ Set gravity_scale to -1.0")
	
	# Method 2: gravity_multiplier variable (custom implementation)
	# This is a variable we add to player.gd ourselves
	# It multiplies get_gravity() to flip its direction
	if "gravity_multiplier" in player:
		player.gravity_multiplier = -1.0  # Negative = upward
		print("  ✓ Set gravity_multiplier to -1.0")
	
	# Debug confirmation
	print("  Player will now fall toward ceiling!")
	print("  Jump direction also reversed!")


# === APPLY NORMAL GRAVITY ===
# Restores normal downward gravity
func _apply_normal_gravity():
	# Restore gravity_scale to normal
	if "gravity_scale" in player:
		player.gravity_scale = 1.0  # Positive = downward gravity
		print("  ✓ Set gravity_scale to 1.0")
	
	# Restore gravity_multiplier to normal
	if "gravity_multiplier" in player:
		player.gravity_multiplier = 1.0  # Positive = downward
		print("  ✓ Set gravity_multiplier to 1.0")
	
	# Debug confirmation
	print("  Player will now fall toward floor!")
	print("  Jump direction restored to normal!")


# === UPDATE BUTTON VISUALS ===
# Changes button color and arrow based on current gravity state
func _update_button_appearance():
	if gravity_flipped:
		# Flipped state: RED button with UP arrow
		button_visual.color = COLOR_FLIPPED
		if label:
			label.text = "↑"  # Up arrow
		print("  Button appearance: 🔴 RED ↑")
	else:
		# Normal state: GREEN button with DOWN arrow
		button_visual.color = COLOR_NORMAL
		if label:
			label.text = "↓"  # Down arrow
		print("  Button appearance: 🟢 GREEN ↓")
