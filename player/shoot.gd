extends Node

@onready var camera_item : CameraItem = %CameraItem
@onready var fps_subviewport : SubViewport = %FPVSubViewport
@onready var photo_screen : PhotoScreen = %PhotoScreen
@onready var fps_camera : Camera3D = %FpsCamera3D

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var result := camera_item.camera_shot.shot()
		
		if result:
			fps_camera.global_transform = camera_item.global_transform
			fps_subviewport.render_target_update_mode = SubViewport.UPDATE_ONCE
			var photo : Texture2D = fps_subviewport.get_texture()
			photo_screen.show_photo(photo)
			print(photo.get_size())
