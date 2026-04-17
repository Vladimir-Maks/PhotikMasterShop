extends Node


@onready var cam : Camera3D = %Camera3D
@onready var pivot : Node3D = %CameraPivot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cam.global_transform = pivot.global_transform
