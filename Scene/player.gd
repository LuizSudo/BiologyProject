extends CharacterBody3D

@export var speed: float = 10.0  # Speed of movement
@export var fast_speed_multiplier: float = 3.0  # Multiplier when holding shift for fast movement
@export var mouse_sensitivity: float = 0.1  # Sensitivity for mouse look

var camera: Camera3D
var look_vertical_angle: float = 0.0  # To handle vertical look

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED  # Capture mouse movement
	camera = $Camera3D  # Get reference to the Camera3D

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		_handle_mouse_input(event)

func _process(delta: float):
	_handle_movement(delta)

func _handle_mouse_input(event: InputEventMouseMotion):
	# Handle horizontal (yaw) rotation
	rotation_degrees.y -= event.relative.x * mouse_sensitivity
	# Handle vertical (pitch) rotation and clamp it between -90 and 90 degrees
	look_vertical_angle -= event.relative.y * mouse_sensitivity
	look_vertical_angle = clamp(look_vertical_angle, -90, 90)
	camera.rotation_degrees.x = look_vertical_angle

func _handle_movement(delta: float):
	var direction = Vector3.ZERO  # Reset movement direction
	# Handle keyboard input (WASD)
	if Input.is_action_pressed("MOVEMENT_UP"):
		direction.z -= 1
	if Input.is_action_pressed("MOVEMENT_DOWN"):
		direction.z += 1
	if Input.is_action_pressed("MOVEMENT_LEFT"):
		direction.x -= 1
	if Input.is_action_pressed("MOVEMENT_RIGHT"):
		direction.x += 1
	# Handle vertical movement (Space for up, Shift for down)
	if Input.is_action_pressed("CAMERA_UP"):
		direction.y += 1
	if Input.is_action_pressed("CAMERA_DOWN"):
		direction.y -= 1
	# Normalize the direction vector to prevent faster diagonal movement
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	# Apply movement speed and fast movement if shift is held
	var current_speed = speed
	if Input.is_action_pressed("move_fast"):
		current_speed *= fast_speed_multiplier
	# Calculate the movement relative to the player's current rotation
	var movement = (transform.basis * direction) * current_speed * delta
	# Move the player by updating global_position
	global_position += movement
