extends AnimatableBody2D

# === EXPORTED CONFIGURATION ===
@export var speed: float = 100.0
@export var pause_duration: float = 1.0
@export var auto_start: bool = true

# === INTERNAL VARIABLES ===
var start_pos: Vector2  # Where the platform starts (its initial position)
var end_pos: Vector2    # Where the platform moves to
var is_moving: bool = false

func _ready():
	# CRITICAL: Enable physics synchronization
	sync_to_physics = true
	
	# The start position is WHERE YOU PLACED THE PLATFORM in the level editor
	# Plus the StartPoint marker offset (which should be 0,0)
	start_pos = global_position + $StartPoint.position
	
	# The end position is the start position plus the EndPoint offset
	end_pos = global_position + $EndPoint.position
	
	# Platform is already at correct position - don't move it!
	
	# Debug output
	print("=== MOVING PLATFORM INITIALIZED ===")
	print("Current Position: ", global_position)
	print("Will move FROM: ", start_pos)
	print("Will move TO: ", end_pos)
	print("Distance: ", start_pos.distance_to(end_pos), " pixels")
	print("Speed: ", speed, " px/s")
	
	if auto_start:
		_start_moving()

func _start_moving():
	if is_moving:
		return
	is_moving = true
	print("🚀 Platform movement started!")
	_move_loop()

func _move_loop():
	while is_moving:
		# Move to end position
		print("Moving to END position...")
		await _move_to_position(end_pos)
		print("✓ Reached END position")
		
		# Pause at end
		if pause_duration > 0:
			await get_tree().create_timer(pause_duration).timeout
		
		# Move back to start position
		print("Moving to START position...")
		await _move_to_position(start_pos)
		print("✓ Reached START position")
		
		# Pause at start
		if pause_duration > 0:
			await get_tree().create_timer(pause_duration).timeout

func _move_to_position(target_pos: Vector2):
	var distance = global_position.distance_to(target_pos)
	var duration = distance / speed
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Use global_position for movement
	tween.tween_property(self, "global_position", target_pos, duration)
	
	await tween.finished

func stop_moving():
	is_moving = false
	print("🛑 Platform stopped")

func resume_moving():
	_start_moving()
