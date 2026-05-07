extends CharacterBody3D

@onready var engine_glow_1 = get_node_or_null("EngineGlow")
@onready var engine_glow_2 = get_node_or_null("EngineGlow2")
@onready var engine_glow_3 = get_node_or_null("EngineGlow3")

@export var acceleration: float = 15
@export var max_speed: float = 35.0
@export var turn_speed: float = 3.5
@export var friction: float = 0.6

var velocity_vec: Vector3 = Vector3.ZERO


func _physics_process(delta):
	var boosting = Input.is_action_pressed("move_forward")

	# --- ROTATION ---
	if Input.is_action_pressed("turn_left"):
		rotate_y(turn_speed * delta)

	if Input.is_action_pressed("turn_right"):
		rotate_y(-turn_speed * delta)

	# --- MOVEMENT ---
	if boosting:
		var forward = -transform.basis.z
		velocity_vec += forward * acceleration * delta

	# --- ENGINE SYSTEM (3 THRUSTERS) ---
	set_engine(engine_glow_1, boosting)
	set_engine(engine_glow_2, boosting)
	set_engine(engine_glow_3, boosting)

	# --- FRICTION ---
	velocity_vec = velocity_vec.lerp(Vector3.ZERO, friction * delta)

	# --- SPEED LIMIT ---
	if velocity_vec.length() > max_speed:
		velocity_vec = velocity_vec.normalized() * max_speed

	# --- MOVE ---
	velocity = velocity_vec
	move_and_slide()

	# --- COLLISIONS ---
	check_collisions()


# ---------------- ENGINE HELPER ----------------

func set_engine(engine_node, boosting: bool):
	if engine_node:
		engine_node.visible = boosting


# ---------------- DAMAGE SYSTEM ----------------

@export var max_health: float = 100.0
var health: float = 100.0


func check_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var speed = velocity_vec.length()

		if speed > 15:
			take_damage((speed - 15) * 2)

		if collision.get_collider() and collision.get_collider().is_in_group("deadly"):
			die()


func take_damage(amount):
	health -= amount
	if health <= 0:
		die()


func die():
	print("GAME OVER")
	queue_free()
