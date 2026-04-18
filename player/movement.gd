extends Node

@onready var body : CharacterBody3D = $"../.."
@onready var cam_pivot : Node3D = %CameraPivot
const SPEED := 5.0
const JUMP_VELOCITY := 4.5
const FRICTION_DELTA := 0.3
const ROTATION_DELTA := 0.1

var wish_velocity := Vector3.ZERO

var wish_direction := Vector3.ZERO
var direction := Vector3.ZERO

func _ready() -> void:
	pass

func _get_direction_diff() -> float:
	var result := 1.0 - absf(wish_direction.length() - direction.length())
	print(result)
	return result


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	wish_direction = (body.transform.basis * Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, cam_pivot.global_rotation.y - body.global_rotation.y)).normalized()
	
	direction = direction.lerp(wish_direction, ROTATION_DELTA)
	
	if wish_direction:
		var diff := _get_direction_diff()
		wish_velocity.x = direction.x * SPEED * diff
		wish_velocity.z = direction.z * SPEED * diff
	else:
		wish_velocity.x = move_toward(wish_velocity.x, 0, FRICTION_DELTA)
		wish_velocity.z = move_toward(wish_velocity.z, 0, FRICTION_DELTA)

	body.velocity.x = lerpf(body.velocity.x, wish_velocity.x, FRICTION_DELTA)
	body.velocity.z = lerpf(body.velocity.z, wish_velocity.z, FRICTION_DELTA)

	body.move_and_slide()
