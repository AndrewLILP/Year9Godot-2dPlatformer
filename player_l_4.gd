extends CharacterBody2D

# this script has animations for the playable character


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta):
	# --- APPLY GRAVITY ---
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# --- JUMP CODE (DISABLED FOR LESSON 1) ---
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#     velocity.y = JUMP_VELOCITY
	
	# --- GET PLAYER INPUT ---
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# --- MOVE THE PLAYER ---
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# === ANIMATION CONTROL === (NEW CODE!)
	# Play walk when moving, idle when stopped
	if direction != 0:
		$AnimatedSprite2D.play("walk")
		# Flip sprite to face movement direction
		$AnimatedSprite2D.flip_h = (direction < 0)
	else:
		$AnimatedSprite2D.play("idle")
	
	# --- EXECUTE THE MOVEMENT ---
	move_and_slide()
