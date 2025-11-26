extends CharacterBody2D

# === MOVEMENT CONSTANTS ===
const FLAP_STRENGTH = -400.0      # How strong each flap is
const MAX_FALL_SPEED = 600.0      # Maximum falling speed
const GRAVITY_SCALE = 1.5         # How fast bird falls

# === ROTATION SETTINGS ===
const MAX_TILT_UP = -30.0         # Tilt up when flapping
const MAX_TILT_DOWN = 90.0        # Tilt down when falling
const ROTATION_SPEED = 3.0        # How fast bird rotates

# === GAME STATE ===
var is_alive = true

# === INITIALIZATION ===
func _ready():
	print("Bird Player Ready!")
	rotation_degrees = 0

# === MAIN PHYSICS FUNCTION ===
func _physics_process(delta):
	if not is_alive:
		return
	
	# Apply gravity - bird always falls
	velocity.y += get_gravity().y * GRAVITY_SCALE * delta
	
	# Limit falling speed
	velocity.y = clamp(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)
	
	# Flap when spacebar pressed
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = FLAP_STRENGTH
		print("FLAP!")
	
	# Update rotation based on velocity
	_update_rotation(delta)
	
	# Move the bird
	move_and_slide()
	
	# Check for collisions
	_check_collisions()

# === ROTATION ===
func _update_rotation(delta):
	var target_rotation = 0.0
	
	if velocity.y < 0:  # Moving up
		target_rotation = MAX_TILT_UP * (velocity.y / FLAP_STRENGTH)
	else:  # Moving down
		target_rotation = MAX_TILT_DOWN * (velocity.y / MAX_FALL_SPEED)
	
	# Smoothly rotate
	rotation_degrees = lerp(rotation_degrees, target_rotation, ROTATION_SPEED * delta)

# === COLLISION DETECTION ===
func _check_collisions():
	# Hit floor or ceiling
	if is_on_floor() or is_on_ceiling():
		_die("Hit boundary!")
	
	# Hit obstacle
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is StaticBody2D:
			_die("Hit obstacle!")

# === DEATH ===
func _die(reason: String):
	if not is_alive:
		return
	
	print("DIED: ", reason)
	is_alive = false
	velocity = Vector2.ZERO
	
	# Turn gray
	if has_node("ColorRect"):
		$ColorRect.color = Color.GRAY
	elif has_node("Sprite2D"):
		$Sprite2D.modulate = Color.GRAY
	
	# Restart after 1 second
	await get_tree().create_timer(1.0).timeout
	get_tree().call_deferred("reload_current_scene")
