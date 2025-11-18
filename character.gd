# character.gd
# Base class for all movable characters (Player, Enemy, NPC, etc.)
# Provides shared functionality: movement, health, gravity, animations
extends CharacterBody2D
class_name Character

# === SHARED PROPERTIES ===
# Health system
@export var max_health: int = 1
var current_health: int = 1

# Movement
var facing_direction: int = 1  # 1 = right, -1 = left

# === INITIALIZATION ===
func _ready():
	# Set health to maximum when spawned
	current_health = max_health
	print(name, " spawned with ", max_health, " health")

# === SHARED PHYSICS ===
# Apply gravity to character
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

# Execute movement physics
func apply_movement() -> void:
	move_and_slide()

# === SHARED HEALTH SYSTEM ===
# Reduce health when damaged
func take_damage(amount: int) -> void:
	current_health -= amount
	print(name, " took ", amount, " damage. Health: ", current_health, "/", max_health)
	
	if current_health <= 0:
		die()

# Restore health (for pickups)
func heal(amount: int) -> void:
	current_health += amount
	# Don't exceed maximum
	if current_health > max_health:
		current_health = max_health
	print(name, " healed ", amount, ". Health: ", current_health, "/", max_health)

# Called when health reaches zero
# Child classes can override for custom behavior
func die() -> void:
	print(name, " died!")
	queue_free()

# === SHARED ANIMATION ===
# Flip sprite based on facing direction
func update_facing_direction() -> void:
	# Try AnimatedSprite2D first
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.flip_h = (facing_direction == -1)
	# Fall back to Sprite2D
	elif has_node("Sprite2D"):
		$Sprite2D.flip_h = (facing_direction == -1)
