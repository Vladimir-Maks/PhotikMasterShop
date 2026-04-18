extends Node

var rays : Array[RayCast3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if this blow up... we are doomed
	for child in %Rays.get_children():
		if child is RayCast3D:
			rays.append(child)


func shot() -> int:
	var hits := 0
	for ray in rays:
		if ray.is_colliding():
			hits += 1
	return hits
