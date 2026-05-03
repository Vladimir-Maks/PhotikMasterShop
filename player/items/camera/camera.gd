extends Node3D
class_name CameraItem

@onready var camera_shot : CameraShot = %CameraShot
@onready var transform_rays : TransformRays = %TransformRays
@onready var anims : AnimationPlayer = %CameraItemAnimations

func equip() -> void:
	anims.play("equip")

func unequip() -> void:
	anims.play("unequip")
