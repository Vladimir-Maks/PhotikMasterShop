extends Node

class_name PhotoScreen

@onready var photo_rect : TextureRect = %PhotoRect
@onready var fade_out : AnimationPlayer = %AnimationPlayer
@onready var timer : Timer = %Timer

func _ready() -> void:
	photo_rect.self_modulate.a = 0

func show_photo(new_photo : Texture2D, want_fadeout : bool = true) -> void:
	if new_photo:
		photo_rect.set_texture(new_photo)
	photo_rect.self_modulate.a = 1.0
	
	if want_fadeout:
		timer.start()

func _on_timer_timeout() -> void:
	fade_out.play("fade_out")
