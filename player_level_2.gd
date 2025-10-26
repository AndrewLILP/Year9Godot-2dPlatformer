extends CharacterBody2D

# === MOVEMENT CONSTANTS ===
const SPEED = 200.0
const JUMP_VELOCITY = -500.0  # For Lesson 2!
var jump_released = false
const MAX_JUMPS = 5
var jump_count = 0


# === MAIN PHYSICS FUNCTION ===
func _physics_process(delta):
	if is_on_floor():
		jump_count = 0

	
	# --- APPLY GRAVITY ---
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_accept") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1  # Used one jump

	
	# --- JUMP CODE (DISABLED FOR LESSON 1) ---
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_released = false
		
		# Add this NEW code right after the jump code:
# Allow shorter jumps by releasing spacebar early
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = velocity.y * 0.5  # Cut jump short

	
	# --- GET PLAYER INPUT ---
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# --- MOVE THE PLAYER ---
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# --- EXECUTE THE MOVEMENT ---
	move_and_slide()

# === GOAL DETECTION SETUP ===
func _ready():
	var goal_box = get_parent().get_node("GoalBox")
	goal_box.body_entered.connect(_on_goal_box_body_entered)

# === GOAL COLLISION RESPONSE ===
func _on_goal_box_body_entered(body):
	if body == self:
		print("Level Complete! Great job!")
		get_tree().change_scene_to_file("res://level_3.tscn")
