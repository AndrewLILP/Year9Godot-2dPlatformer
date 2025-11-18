# player.gd
# Player-controlled character
# Inherits movement, health, and physics from Character
extends Character

# === PLAYER CONSTANTS ===
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# === INITIALIZATION ===
func _ready():
	# Call parent's initialization first
	super._ready()
	
	# Player-specific setup
	max_health = 3
	current_health = 3
	
	print("Player ready with ", max_health, " hearts")
	
	# Connect to goal box (if it exists)
	if get_parent().has_node("GoalBox"):
		var goal_box = get_parent().get_node("GoalBox")
		goal_box.body_entered.connect(_on_goal_box_body_entered)

# === PLAYER PHYSICS ===
func _physics_process(delta):
	# --- GRAVITY (from parent) ---
	apply_gravity(delta)
	
	# --- JUMP (player-specific) ---
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
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
	# Check if we have AnimatedSprite2D
	if has_node("AnimatedSprite2D"):
		if direction != 0:
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
	
	# Flip sprite to face movement direction
	update_facing_direction()
	
	# --- EXECUTE MOVEMENT (from parent) ---
	apply_movement()

# === GOAL DETECTION ===
func _on_goal_box_body_entered(body):
	if body == self:
		print("Level Complete!")
		get_tree().change_scene_to_file("res://level_2.tscn")

# === CUSTOM DEATH BEHAVIOR ===
# Override parent's die() function
func die() -> void:
	print("GAME OVER!")
	# Restart level instead of just disappearing
	get_tree().call_deferred("reload_current_scene")
