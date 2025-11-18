# goal_box.gd
# Detects when player reaches the goal and triggers level completion
# This script handles ONLY goal detection - GameManager handles level loading
extends Area2D

# === VISUAL CUSTOMIZATION ===
# Change this in Inspector per instance for different colored goals
@export var goal_color: Color = Color.GOLD

# Has this goal been triggered already?
var is_triggered: bool = false

# === INITIALIZATION ===
func _ready():
	# Connect collision detection signal
	body_entered.connect(_on_body_entered)
	
	# Set visual appearance if ColorRect exists
	if has_node("ColorRect"):
		$ColorRect.color = goal_color
	
	print("🎯 GoalBox ready at: ", global_position)

# === COLLISION DETECTION ===
func _on_body_entered(body: Node2D) -> void:
	# Prevent double-triggering
	if is_triggered:
		return
	
	print("GoalBox detected: ", body.name)
	
	# Check if it's the player
	if "Player" in body.name:
		print("✓ Player reached goal!")
		is_triggered = true
		
		# Tell GameManager to complete the level
		GameManager.complete_level()
		
		# ❌ OLD WAY (causes error):
		# monitoring = false
		
		# ✅ NEW WAY (safe):
		set_deferred("monitoring", false)
		
		# Optional: Play celebration animation
		play_completion_effect()

# === VISUAL EFFECTS ===

# Make goal box pulse continuously (called every frame)
func _process(_delta: float) -> void:
	if has_node("ColorRect") and not is_triggered:
		# Pulse effect using sine wave
		var pulse = (sin(Time.get_ticks_msec() * 0.005) + 1.0) * 0.5
		$ColorRect.modulate.a = 0.5 + (pulse * 0.5)  # Alpha between 0.5-1.0

# Play effect when player reaches goal
func play_completion_effect() -> void:
	if has_node("ColorRect"):
		# Flash bright
		$ColorRect.modulate = Color.WHITE
		
		# Create tween for fade effect
		var tween = create_tween()
		tween.tween_property($ColorRect, "modulate:a", 0.0, 0.5)
