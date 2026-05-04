extends Node
class_name ActionShoot


@onready var camera_item : CameraItem = %CameraItem
@onready var fps_subviewport : SubViewport = %FPVSubViewport
@onready var photo_screen : PhotoScreen = %PhotoScreen

@onready var item_interactions : ItemInteractions = %ItemIntercations

@onready var shoot_timer : Timer = %ShootTimer

@onready var hands : Node3D = %Hands
@onready var action_shoot : ActionShoot = %Shoot
@onready var fps_camera : Camera3D = %FpsCamera3D

enum {
	IN_HAND,
	TAKING_AIM,
}

var state := IN_HAND

func _ready() -> void:
	var photo : Texture2D = fps_subviewport.get_texture()
	photo_screen.set_target_texture(photo)

func _physics_process(_delta: float) -> void:
	fps_camera.global_transform = camera_item.global_transform
	if shoot_timer.time_left > 0.0:
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		match state:
			IN_HAND:
				take_aim()
			TAKING_AIM:
				pass
	
	if Input.is_action_just_released("ui_accept"):
		match state:
			IN_HAND:
				pass
			TAKING_AIM:
				clear_take_aim()
				action_shoot.shoot()
	
	if Input.is_action_just_pressed("ui_cancel") or not item_interactions.is_equiped():
		clear_take_aim()

func take_aim() -> void:
	state = TAKING_AIM
	fps_subviewport.set_update_mode(SubViewport.UPDATE_ALWAYS)
	await RenderingServer.frame_post_draw
	photo_screen.show_preview()

func clear_take_aim() -> void:
	photo_screen.hide_preview()
	fps_subviewport.set_update_mode(SubViewport.UPDATE_DISABLED)
	state = IN_HAND

func shoot() -> void:
	if item_interactions.state != ItemInteractions.EQUIPED:
		return
	
	if shoot_timer.time_left > 0.0:
		return
	
	var result := camera_item.camera_shot.shot()
	shoot_timer.start()
	if result:
		photo_screen.show_photo()
