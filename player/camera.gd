extends Node

@onready var cam : Camera3D = %Camera3D
@onready var pivot: Node3D = %CameraPivot
@onready var anchor: SpringArm3D = %CameraAnchor
@onready var player_cam_target: Node3D = %PlayerCameraTarget

@export_group("Following Target")
@export var targets: Dictionary[String, Node3D] # Temp, better switch to weight/priority system
@export var follow_speed: float = 5.0
@export var offset: Vector3 = Vector3(0, 1.5, 0)
var next_following_pos: Vector3 = Vector3.ZERO

# --- DEPRECATED, but can be used for cutscenes
@export_group("Rotation") 
@export_range(0.0, 1.0) var mouse_sensitivity = 0.3
@export var rotation_speed: float = 15.0
@export var pitch_limit: Vector2 = Vector2(-50, -15)
var yaw: float = 45.0
var pitch: float = -60.0
var is_rotating: bool = false
# ---

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

func _ready() -> void:
	if not targets:
		add_target(player_cam_target)
	cam.global_transform = pivot.global_transform
	add_target(get_tree().root.get_child(0).get_node("TestCamBox")) # test target system
	
	if anchor:
		anchor.spring_length = default_distance
		to_distance = default_distance 
		#spring_arm.add_excluded_object(target.get_rid()) # ooooh collisions oooooh

func add_target(new_target: Node3D):
	if new_target:
		targets[new_target.name] = new_target

func remove_target(old_target: Node3D):
	targets.erase(old_target.name)

func flush_targets(reset_to_player: bool = true):
	targets.clear()
	if reset_to_player:
		add_target(player_cam_target)

func _physics_process(delta: float) -> void:
	if anchor:
		_process_distance(delta)
		_follow_targets(delta)
		_apply_rotation(delta) # DEPRECATED, but can be used for cutscenes
	cam.global_transform = pivot.global_transform

func _process_distance(delta: float) -> void:
	anchor.spring_length = lerp(anchor.spring_length, to_distance, zoom_speed * delta)  # YOU SHOULD LERP THIS SHIT NOW
	distance_percentage = (to_distance - min_distance) / (max_distance - min_distance)
	pitch = clamp(min_tilt + (max_tilt - min_tilt) * distance_percentage, min_tilt, max_tilt)
	fov = clamp(min_fov + (max_fov * 2 - min_fov) * distance_percentage, min_fov, max_fov)
	anchor.rotation.x = lerp_angle(anchor.rotation.x, deg_to_rad(-pitch), zoom_speed * delta)
	
func _follow_targets(delta: float) -> void:
	next_following_pos =  anchor.global_position.lerp(_targets_midpoint(), follow_speed * delta) # smooooooooooth
	anchor.global_position.x = next_following_pos.x
	anchor.global_position.z = next_following_pos.z

func _targets_midpoint() -> Vector3: # Or Vector3
	if targets.is_empty():
		printerr("No camera targets?")
		return Vector3.ZERO

	var center = Vector3.ZERO
	for target in targets.values():
		center += target.global_position

	return center / targets.size()

# --- DEPRECATED, but can be used for cutscenes
func _apply_rotation(delta: float) -> void:
	anchor.rotation.y = lerp_angle(anchor.rotation.y , deg_to_rad(yaw), rotation_speed * delta)
# ---

func _unhandled_input(event: InputEvent) -> void:
	# --- DEPRECATED, but can be used for cutscenes
	#if event is InputEventMouseMotion and Input.is_action_pressed("camera_free_look"):
		#yaw -= event.screen_relative.x * mouse_sensitivity
		#is_rotating = true
	#else: is_rotating = false
	# ---

	if Input.is_action_pressed("camera_zoom_in"):
		to_distance = clamp(to_distance - zoom_step, min_distance, max_distance)
	elif Input.is_action_pressed("camera_zoom_out"):
		to_distance = clamp(to_distance + zoom_step, min_distance, max_distance)
