extends Control

class_name PhotoScreen

@onready var photo_rect : TextureRect = %PhotoRect
@onready var fade_out : AnimationPlayer = %AnimationPlayer
@onready var timer : Timer = %Timer

@onready var background : Panel = %PanelBackground

func _ready() -> void:
	modulate.a = 0.0
	background.modulate.a = 0.0

func set_target_texture(target_texture : Texture2D) -> void:
	photo_rect.set_texture(target_texture)

func show_preview() -> void:
	modulate.a = 1.0
	background.modulate.a = 0.0

func hide_preview() -> void:
	modulate.a = 0.0
	background.modulate.a = 1.0

func show_photo(want_fadeout : bool = true) -> void:
	modulate.a = 1.0
	background.modulate.a = 1.0
	
	if want_fadeout:
		timer.start()

func hide_photo() -> void:
	modulate.a = 0.0
	background.modulate.a = 0.0

func _on_timer_timeout() -> void:
	fade_out.play("fade_out")
