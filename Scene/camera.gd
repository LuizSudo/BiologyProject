extends Camera3D

# Variables of state of mouse
var is_dragging = false
var move_speed = 5.0

# Mouse movement sensitivity 
var rotation_sensitivity = 0.1

func _ready():
	# Create a input procress
	set_process_input(true)

func _process(delta: float) -> void:
	handle_movement(delta)

func handle_movement(delta):
	var direction = Vector3()
	
	if Input.is_action_pressed("MOVEMENT_UP"):
		direction -= transform.basis.z
	if Input.is_action_pressed("MOVEMENT_DOWN"):
		direction += transform.basis.z
	if Input.is_action_pressed("MOVEMENT_LEFT"):
		direction -= transform.basis.x
	if Input.is_action_pressed("MOVEMENT_RIGHT"):
		direction += transform.basis.x
	
	if direction != Vector3():
		direction = direction.normalized()
	position += direction * move_speed * delta
	

func handle_rotation(delta):
	var rotation_input = Vector3.ZERO
	
	if Input.is_action_pressed("MOVEMENT_LEFT"):
		rotation_input.y -= 1
	if Input.is_action_pressed("MOVEMENT_RIGHT"):
		rotation_input.y += 1
	if Input.is_action_pressed("MOVEMENT_UP"):
		rotation_input.x -= 1
	if Input.is_action_pressed("MOVEMENT_DOWN"):
		rotation_input.x += 1
	
	rotate_x(deg_to_rad(rotation_input.x * delta))
	rotate_y(deg_to_rad(rotation_input.y * delta))
