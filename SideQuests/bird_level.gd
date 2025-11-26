extends Node2D

# === SETTINGS ===
const SCROLL_SPEED = 200.0         # How fast obstacles move
const OBSTACLE_SPACING = 400.0     # Distance between obstacles
const SPAWN_X = 1200.0             # Where obstacles appear (right)
const RECYCLE_X = -100.0           # Where obstacles disappear (left)

# === SCORE ===
var score = 0

# === OBSTACLES ===
var obstacles = []

# === INITIALIZATION ===
func _ready():
	print("=== BIRD LEVEL STARTED ===")
	
	# Wait for everything to load
	await get_tree().process_frame
	
	# Setup obstacles
	_setup_obstacles()
	
	# Connect score zones
	_connect_score_zones()

# === OBSTACLE SETUP ===
func _setup_obstacles():
	# Find all obstacles in the "obstacles" group
	obstacles = get_tree().get_nodes_in_group("obstacles")
	print("Found ", obstacles.size(), " obstacles")
	
	# Position them in a row
	for i in range(obstacles.size()):
		obstacles[i].position.x = SPAWN_X + (i * OBSTACLE_SPACING)

# === UPDATE LOOP ===
func _process(delta):
	# Move each obstacle left
	for obstacle in obstacles:
		obstacle.position.x -= SCROLL_SPEED * delta
		
		# If obstacle goes off left side, move to right side
		if obstacle.position.x < RECYCLE_X:
			_recycle_obstacle(obstacle)

# === RECYCLE OBSTACLE ===
func _recycle_obstacle(obstacle):
	# Find rightmost obstacle
	var rightmost_x = RECYCLE_X
	for other in obstacles:
		if other.position.x > rightmost_x:
			rightmost_x = other.position.x
	
	# Place after rightmost obstacle
	obstacle.position.x = rightmost_x + OBSTACLE_SPACING
	print("Recycled obstacle")

# === SCORE ZONE CONNECTION ===
func _connect_score_zones():
	var zones = get_tree().get_nodes_in_group("score_zones")
	print("Found ", zones.size(), " score zones")
	
	for zone in zones:
		if zone.has_signal("scored"):
			zone.scored.connect(_on_score)

# === SCORE HANDLER ===
func _on_score():
	score += 1
	print("Score: ", score)
	
	# Update score label
	if has_node("ScoreLabel"):
		$ScoreLabel.text = "Score: " + str(score)
