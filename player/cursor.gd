extends Node

@onready var cursor: Control = %Cursor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"../Camera".is_rotating:
		return
	cursor.position = get_viewport().get_mouse_position()
