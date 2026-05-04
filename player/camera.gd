extends Node

@onready var cam : Camera3D = %Camera3D
@onready var pivot: Node3D = %CameraPivot
@onready var anchor: SpringArm3D = %CameraAnchor

@export_group("Following Target")
@export var target: Node3D
@export var follow_speed: float = 5.0
@export var offset: Vector3 = Vector3(0, 1.5, 0)

@export_group("Rotation")
@export_range(0.0, 1.0) var mouse_sensitivity = 0.3
@export var rotation_speed: float = 15.0
@export var pitch_limit: Vector2 = Vector2(-50, -15)
var yaw: float = 45.0
var pitch: float = -60.0

@export_group("Distance")
@export var default_distance: float = 14.0
@export var min_distance: float = 8.0
@export var max_distance: float = 17.0
var to_distance: float
var distance_percentage: float

@export_group("Zooming")
@export var zoom_step: float = 2.0
@export var zoom_speed: float = 1.0
@export var min_tilt: float = 20.0
@export var max_tilt: float = 60.0

@export_group("FOV")
@export var min_fov: float = 30.0
@export var max_fov: float = 75.0
var fov: float = 75.0

var is_rotating: bool = false
var last_mouse_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	if not target:
		target = %PlayerCameraTarget
	cam.global_transform = pivot.global_transform
	
	if anchor:
		anchor.spring_length = default_distance
		to_distance = default_distance 
		#spring_arm.add_excluded_object(target.get_rid()) # ooooh collisions oooooh

func _physics_process(delta: float) -> void:
	if anchor:
		_process_distance(delta)
		_follow_target(delta)
		_apply_rotation(delta)
	cam.global_transform = pivot.global_transform

func _process(delta: float) -> void:
	Input.MOUSE_MODE_CONFINED
	if is_rotating:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		return
	last_mouse_pos = $"../../Viewport".get_viewport().get_mouse_position() # test
	

func _process_distance(delta: float) -> void:
	anchor.spring_length = lerp(anchor.spring_length, to_distance, zoom_speed * delta)  # YOU SHOULD LERP THIS SHIT NOW
	distance_percentage = (to_distance - min_distance) / (max_distance - min_distance)
	pitch = clamp(min_tilt + (max_tilt - min_tilt) * distance_percentage, min_tilt, max_tilt)
	fov = clamp(min_fov + (max_fov * 2 - min_fov) * distance_percentage, min_fov, max_fov)
	anchor.rotation.x = lerp_angle(anchor.rotation.x, deg_to_rad(-pitch), zoom_speed * delta)
	

func _follow_target(delta: float) -> void:
	anchor.global_position = anchor.global_position.lerp(target.global_position, follow_speed * delta) # smooooooooooth

func _apply_rotation(delta: float) -> void:
	anchor.rotation.y = lerp_angle(anchor.rotation.y , deg_to_rad(yaw), rotation_speed * delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("camera_free_look"):
		yaw -= event.screen_relative.x * mouse_sensitivity
		is_rotating = true
	else: is_rotating = false
	
	if Input.is_action_just_released("camera_free_look"):
		Input.warp_mouse(last_mouse_pos)

	if Input.is_action_pressed("camera_zoom_in"):
		to_distance = clamp(to_distance - zoom_step, min_distance, max_distance)
	elif Input.is_action_pressed("camera_zoom_out"):
		to_distance = clamp(to_distance + zoom_step, min_distance, max_distance)
