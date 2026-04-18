extends Node
class_name TransformRays

@onready var rays_node : Node3D = %RaysPivot

func transform_rays(new_global_transform : Transform3D) -> void:
	if new_global_transform:
		rays_node.global_transform = new_global_transform

func set_focus(focus : float) -> void:
	pass
