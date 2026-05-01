extends Node

@onready var hands : Node3D = %Hands
@onready var camera_item : CameraItem = %CameraItem
@onready var action_shoot : ActionShoot = %Shoot
@onready var fps_camera : Camera3D = %FpsCamera3D
@onready var fpv_sub_viewport_container : SubViewportContainer = %FPVSubViewportContainer

@onready var item_interactions = %ItemIntercations


enum {
	IN_HAND,
	TAKING_AIM,
}

var state := IN_HAND

func _ready() -> void:
	fpv_sub_viewport_container.hide()

func _physics_process(_delta: float) -> void:
	fps_camera.global_transform = camera_item.global_transform
	
	if Input.is_action_just_pressed("ui_accept"):
		match state:
			IN_HAND:
				state = TAKING_AIM
				fpv_sub_viewport_container.show()
			TAKING_AIM:
				pass
	
	if Input.is_action_just_released("ui_accept"):
		match state:
			IN_HAND:
				pass
			TAKING_AIM:
				action_shoot.shoot()
				clear_take_aim()
	
	if Input.is_action_just_pressed("ui_cancel") or not item_interactions.is_equiped():
		clear_take_aim()

func clear_take_aim() -> void:
	fpv_sub_viewport_container.hide()
	state = IN_HAND
