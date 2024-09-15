extends CharacterBody3D

# Variáveis de configuração
var move_speed = 5.0  # Velocidade de movimentação
var rotation_speed = 2.0  # Velocidade de rotação
var gravity = -9.8  # Gravidade para o personagem

func _physics_process(delta):
	# Resetar a velocidade horizontal (x e z) a cada frame
	velocity.x = 0
	velocity.z = 0
	handle_movement(delta)
	apply_gravity(delta)
	# Move o personagem
	move_and_slide()

func handle_movement(delta):
	# Capturar input para movimentação usando teclado ou gamepad
	var input_direction = Vector3.ZERO
	if Input.is_action_pressed("MOVEMENT_UP"):
		input_direction.x -= 1  # Movimentar para frente
	if Input.is_action_pressed("MOVEMENT_DOWN"):
		input_direction.x += 1  # Movimentar para trás
	if Input.is_action_pressed("MOVEMENT_LEFT"):
		input_direction.z += 1  # Movimentar para a esquerda
	if Input.is_action_pressed("MOVEMENT_RIGHT"):
		input_direction.z -= 1  # Movimentar para a direita
	
	# Normaliza o vetor de direção para garantir velocidade uniforme
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
		
		var rotated_direction = global_transform.basis * input_direction
		
		# Calcular a velocidade de movimentação
		velocity.x = input_direction.x * move_speed
		velocity.z = input_direction.z * move_speed
		rotate_character(rotated_direction, delta)
	# Rotacionar o personagem usando teclado ou gamepad
	handle_rotation(delta)

func rotate_character(direction: Vector3, delta):
	var target_rotation = direction.angle_to(Vector3.FORWARD)
	
	var current_rotation  = rotation_degrees.y
	var new_rotation = lerp_angle(current_rotation, rad_to_deg(target_rotation), rotation_speed * delta)
	
	rotation_degrees.y = new_rotation

func handle_rotation(delta):
	var rotation_input = 0.0
	# Rotaciona o personagem para a esquerda ou direita
	if Input.is_action_pressed("CAMERA_LEFT"):
		rotation_input += 1  # Rotaciona para a esquerda
	if Input.is_action_pressed("CAMERA_RIGHT"):
		rotation_input -= 1  # Rotaciona para a direita
	# Aplica a rotação no eixo Y (horizontal)
	if rotation_input != 0.0:
		rotate_y(rotation_input * rotation_speed * delta)

func apply_gravity(delta):
	# Aplica a gravidade no personagem
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # Reseta a velocidade vertical ao tocar o chão
