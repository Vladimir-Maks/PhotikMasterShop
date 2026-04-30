extends Node
class_name ItemInteractions

enum {
	NO_ITEM = 0,
	EQUIPED = 1,
	UNEQUIPED = 2,
	#In animation states
	IN_EQUIPING = 4,
	IN_UNEQUIPING = 5,
}

@onready var camera_item : CameraItem = %CameraItem
@onready var equip_timer : Timer = %EquipTimer

var state := UNEQUIPED

func is_equiped() -> bool:
	return state == EQUIPED

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		match state:
			NO_ITEM:
				_on_no_item()
			EQUIPED:
				_on_equip()
			UNEQUIPED:
				_on_unequiped()
			IN_EQUIPING:
				_on_in_equiped()
			IN_UNEQUIPING:
				_on_in_unequiping()
			_:
				printerr("UNEXPECTED STATE VALUE")

func _on_no_item() -> void:
	pass

func _on_equip() -> void:
	equip_timer.start()
	camera_item.unequip()
	state = IN_UNEQUIPING

func _on_unequiped() ->void:
	equip_timer.start()
	camera_item.equip()
	state = IN_EQUIPING

func _on_in_equiped() -> void:
	pass

func _on_in_unequiping() -> void:
	pass

func _on_equip_timer_timeout() -> void:
	match state:
		IN_EQUIPING:
			state = EQUIPED
		IN_UNEQUIPING:
			state = UNEQUIPED
		_:
			printerr("UNEXPECTED STATE VALUE")
