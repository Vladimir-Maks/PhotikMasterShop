extends Node

@onready var body : CharacterBody3D = $"../.."
@onready var cam_pivot : Node3D = %CameraPivot
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var direction := (body.transform.basis * Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, cam_pivot.global_rotation.y - body.global_rotation.y)).normalized()
	
	if direction:
		body.velocity.x = direction.x * SPEED
		body.velocity.z = direction.z * SPEED
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, SPEED)
		body.velocity.z = move_toward(body.velocity.z, 0, SPEED)

	body.move_and_slide()
