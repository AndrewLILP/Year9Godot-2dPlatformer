# game_manager.gd
# Singleton that manages game state, level progression, and player status
# Accessible from anywhere as: GameManager.function_name()
extends Node

# === LEVEL MANAGEMENT ===
# List of all levels in order
var levels: Array[String] = [
	"res://level_1.tscn",
	"res://level_2.tscn",
	# Add more levels here as you create them!
	# "res://level_3.tscn",
	# "res://level_4.tscn",
]

# Current level index (0 = first level, 1 = second level, etc.)
var current_level_index: int = 0

# === PLAYER STATE ===
var player_lives: int = 3
var player_score: int = 0
var player_max_health: int = 3

# === PLAYER REFERENCE ===
# Store reference to player so we can access from anywhere
var player: CharacterBody2D = null

# === SIGNALS ===
# Other objects can listen for these events
signal level_completed
signal player_died
signal game_over
signal score_changed(new_score: int)
signal lives_changed(new_lives: int)

# === INITIALIZATION ===
func _ready():
	print("═══════════════════════════════════")
	print("   GAME MANAGER INITIALIZED")
	print("═══════════════════════════════════")
	print("Total levels: ", levels.size())
	print("Starting level: ", levels[current_level_index])
	print("Starting lives: ", player_lives)
	print("═══════════════════════════════════")

# === LEVEL TRANSITION FUNCTIONS ===

# Load the next level in the sequence
func load_next_level() -> void:
	current_level_index += 1
	
	# Check if we completed all levels
	if current_level_index >= levels.size():
		print("🎉 ═══════════════════════════════════ 🎉")
		print("   ALL LEVELS COMPLETED!")
		print("   FINAL SCORE: ", player_score)
		print("🎉 ═══════════════════════════════════ 🎉")
		show_victory_screen()
		return
	
	# Load next level
	print("→ Loading next level: ", levels[current_level_index])
	level_completed.emit()
	get_tree().call_deferred("change_scene_to_file", levels[current_level_index])

# Reload current level (for player death)
func restart_current_level() -> void:
	print("↻ Restarting level: ", levels[current_level_index])
	get_tree().call_deferred("change_scene_to_file", levels[current_level_index])

# Load a specific level by index (0 = first level)
func load_level(level_index: int) -> void:
	if level_index >= 0 and level_index < levels.size():
		current_level_index = level_index
		print("→ Loading level ", level_index + 1, ": ", levels[current_level_index])
		get_tree().call_deferred("change_scene_to_file", levels[current_level_index])
	else:
		print("ERROR: Invalid level index: ", level_index)

# === PLAYER MANAGEMENT ===

# Register the player when level loads
func register_player(player_node: CharacterBody2D) -> void:
	player = player_node
	print("✓ Player registered: ", player.name)

# Called when player reaches goal
func complete_level() -> void:
	print("")
	print("🎯 ═══════════════════════════════════")
	print("   LEVEL COMPLETE!")
	print("   Score: ", player_score)
	print("   Lives: ", player_lives)
	print("═══════════════════════════════════")
	print("")
	
	# Small delay for satisfaction
	await get_tree().create_timer(0.5).timeout
	load_next_level()

# Called when player dies
func on_player_death() -> void:
	player_lives -= 1
	print("")
	print("💀 Player died! Lives remaining: ", player_lives)
	lives_changed.emit(player_lives)
	
	if player_lives <= 0:
		# Game over!
		print("")
		print("☠️ ═══════════════════════════════════ ☠️")
		print("        GAME OVER")
		print("   Final Score: ", player_score)
		print("☠️ ═══════════════════════════════════ ☠️")
		print("")
		game_over.emit()
		
		# Wait before resetting
		await get_tree().create_timer(2.0).timeout
		reset_game()
	else:
		# Respawn player
		print("↻ Respawning...")
		await get_tree().create_timer(1.0).timeout
		restart_current_level()

# === SCORE MANAGEMENT ===

# Add points to score
func add_score(points: int) -> void:
	player_score += points
	print("★ Score: ", player_score, " (+", points, ")")
	score_changed.emit(player_score)

# Reset score
func reset_score() -> void:
	player_score = 0
	score_changed.emit(player_score)

# === GAME STATE ===

# Reset game to beginning
func reset_game() -> void:
	print("")
	print("═══════════════════════════════════")
	print("   RESETTING GAME...")
	print("═══════════════════════════════════")
	
	player_lives = 3
	player_score = 0
	current_level_index = 0
	
	lives_changed.emit(player_lives)
	score_changed.emit(player_score)
	
	# Small delay before restarting
	await get_tree().create_timer(1.0).timeout
	load_level(0)

# Show victory screen when all levels complete
func show_victory_screen() -> void:
	# TODO: Create victory.tscn scene for celebration
	print("🏆 Showing victory screen...")
	
	# For now, wait then restart
	await get_tree().create_timer(3.0).timeout
	reset_game()

# === UTILITY FUNCTIONS ===

# Get current level number (for UI display)
# Returns 1 for first level, 2 for second, etc. (humans count from 1!)
func get_current_level_number() -> int:
	return current_level_index + 1

# Check if there's a next level
func has_next_level() -> bool:
	return current_level_index + 1 < levels.size()

# Get total number of levels
func get_total_levels() -> int:
	return levels.size()
