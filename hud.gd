# hud.gd
# Heads-Up Display - Shows score, lives, level, AND gravity direction
# Stays on screen even when camera moves
extends CanvasLayer

# === COLOR CONSTANTS (from gravity_button.gd) ===
# Using same colors as GravityButton for consistency
const COLOR_NORMAL = Color(0, 1, 0)    # Green = normal gravity (down)
const COLOR_FLIPPED = Color(1, 0, 0)   # Red = flipped gravity (up)

# === UI ELEMENT REFERENCES ===
@onready var score_label = $ScoreLabel
@onready var lives_label = $LivesLabel
@onready var level_label = $LevelLabel
@onready var gravity_label = $"GravityIndicator"

# === INITIALIZATION ===
func _ready():
	add_to_group("hud")
	print("═══════════════════════════════════")
	print("   HUD INITIALIZED")
	print("═══════════════════════════════════")
	
	# Connect to GameManager signals
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	
	# Initialize display with current values
	update_score(GameManager.player_score)
	update_lives(GameManager.player_lives)
	update_level(GameManager.get_current_level_number())
	update_gravity(1.0)  # Start with normal gravity
	
	print("✓ HUD connected to GameManager signals")

# === UPDATE FUNCTIONS ===

# Update score display
func update_score(new_score: int) -> void:
	score_label.text = "Score: " + str(new_score)

# Update lives display
func update_lives(new_lives: int) -> void:
	# Option A: Use hearts (emoji or symbols)
	var hearts = ""
	for i in range(new_lives):
		hearts += "❤"  # or use "♥" or "<3"
	lives_label.text = "Lives: " + hearts
	
	# Option B: Use numbers (simpler)
	# lives_label.text = "Lives: " + str(new_lives)
	
	# Option C: Use both
	# lives_label.text = "Lives: " + str(new_lives) + " " + hearts

# Update level display
func update_level(level_number: int) -> void:
	level_label.text = "Level: " + str(level_number)

# === ★ NEW: UPDATE GRAVITY INDICATOR ===
# Changes the label text and color based on gravity direction
# gravity_multiplier: 1.0 = normal (down), -1.0 = flipped (up)
func update_gravity(gravity_multiplier: float) -> void:
	# Safety check - make sure the label exists
	if not gravity_label:
		print("❌ ERROR: GravityIndicator label not found!")
		return
	
	if gravity_multiplier == -1.0:
		# FLIPPED GRAVITY (upward)
		gravity_label.text = "↑ Gravity"
		gravity_label.add_theme_color_override("font_color", COLOR_FLIPPED)
		print("HUD: Gravity indicator → RED ↑ (flipped)")
	else:
		# NORMAL GRAVITY (downward)
		gravity_label.text = "↓ Gravity"
		gravity_label.add_theme_color_override("font_color", COLOR_NORMAL)
		print("HUD: Gravity indicator → GREEN ↓ (normal)")
# === SIGNAL HANDLERS ===

# Called when GameManager.score_changed is emitted
func _on_score_changed(new_score: int) -> void:
	print("HUD: Score updated to ", new_score)
	update_score(new_score)
	
	# Optional: Play sound effect
	# $ScoreSound.play()
	
	# Optional: Animate the label
	animate_score_change()

# Called when GameManager.lives_changed is emitted
func _on_lives_changed(new_lives: int) -> void:
	print("HUD: Lives updated to ", new_lives)
	update_lives(new_lives)
	
	# Optional: Flash red when losing a life
	if new_lives < GameManager.player_lives:
		animate_lives_lost()

# === OPTIONAL: ANIMATIONS ===

# Make score label briefly grow when changed
func animate_score_change() -> void:
	var tween = create_tween()
	# Scale up
	tween.tween_property(score_label, "scale", Vector2(1.2, 1.2), 0.1)
	# Scale back down
	tween.tween_property(score_label, "scale", Vector2(1.0, 1.0), 0.1)

# Flash lives label red when losing a life
func animate_lives_lost() -> void:
	var tween = create_tween()
	# Flash red
	tween.tween_property(lives_label, "modulate", Color.RED, 0.1)
	# Back to white
	tween.tween_property(lives_label, "modulate", Color.WHITE, 0.1)
	# Flash again
	tween.tween_property(lives_label, "modulate", Color.RED, 0.1)
	tween.tween_property(lives_label, "modulate", Color.WHITE, 0.1)
