extends CharacterBody3D

const SPEED = 5.0

@onready var camera = $Camera3D

var mouse_sensibilidade = 0.003

var rotacao_camera_x = 0.0
var rotacao_corpo_y = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	


func _unhandled_input(event):

	if event is InputEventMouseMotion:

		# Rotação esquerda/direita
		rotacao_corpo_y -= event.relative.x * mouse_sensibilidade

		# Rotação cima/baixo
		rotacao_camera_x -= event.relative.y * mouse_sensibilidade

		# Limite da câmera pra cima e baixo
		rotacao_camera_x = clamp(rotacao_camera_x, deg_to_rad(-90), deg_to_rad(90))

		# Limite pros lados
		rotacao_corpo_y = clamp(rotacao_corpo_y, deg_to_rad(-360), deg_to_rad(360))

		rotation.y = rotacao_corpo_y
		camera.rotation.x = rotacao_camera_x


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("right", "left", "backward", "forward")

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
