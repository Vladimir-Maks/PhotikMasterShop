extends Node
class_name CameraShot

@onready var pivot : Node3D = %RaysPivot
@onready var focal_point : Node3D = %FocalPoint

@export var collision_mask : int = 0xFFFFFFFF

const POINT_SCALE = 0.1
const RAYCAST_LENGTH = 200.0

var rays_guide : Array[Vector3] = []

func _ready() -> void:
	var guide_file = load("res://player/items/camera/rays_guide.tres") as Curve2D
	for i in range(guide_file.point_count):
		var point := guide_file.get_point_position(i) * POINT_SCALE
		rays_guide.append(Vector3(point.x, point.y, 0))

func shot() -> void:
	var results : Array[Dictionary] = [] # intersect_ray return value is ass
	var space_state := pivot.get_world_3d().direct_space_state
	
	for ray_guide in rays_guide:
		var from := pivot.global_position + ray_guide
		var to := (focal_point.global_position - from).normalized() * RAYCAST_LENGTH
		print(focal_point.global_position, to)
		#everything before facal point is ignored
		var query := PhysicsRayQueryParameters3D.create(focal_point.global_position, to, collision_mask)
		query.collide_with_areas = true
		
		var result := space_state.intersect_ray(query)
		results.append(result)
		if result:
			print("success")
