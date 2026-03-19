extends CharacterBody3D

#-----------------------------------------
# SETTINGS
#-----------------------------------------

const VIEW_PITCH_ANGLE_LIMIT: float = 89.0
const JUMP_VELOCITY: float = 2.0

@export var movement_speed: float = 5.0
@export var camera_sensitivity: float = 0.002

#-----------------------------------------
# PROPERTIES
#-----------------------------------------

@onready var head: Node3D = $head
@onready var camera: Camera3D = $head/camera
var has_key: bool = false

#-----------------------------------------
# 
#-----------------------------------------

func add_to_inventory(t_item: String) -> void:
	if (t_item == "key"):
		has_key = true

#-----------------------------------------
# LIFECYCLE
#-----------------------------------------

func _ready() -> void: 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#-----------------------------------------

func _unhandled_input(t_event: InputEvent) -> void:
	if t_event is InputEventMouseMotion:
		head.rotate_y(-t_event.relative.x * camera_sensitivity)
		camera.rotate_x(-t_event.relative.y * camera_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -deg_to_rad(VIEW_PITCH_ANGLE_LIMIT), deg_to_rad(VIEW_PITCH_ANGLE_LIMIT))
	
#-----------------------------------------

func _physics_process(t_delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * t_delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle velocity.
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)
	
	# Move the character.
	move_and_slide()
	
	# Iterate over collisions and apply a force to any rigid body we collide with.
	for i in get_slide_collision_count():
		var collision: KinematicCollision3D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		if collider is RigidBody3D:
			var force_dir: Vector3 = -collision.get_normal()
			collider.apply_central_impulse(force_dir * 0.5)

#-----------------------------------------
