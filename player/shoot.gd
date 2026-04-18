extends Node


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		$"../../../Hands/Node3D".camera_shot.shot()
