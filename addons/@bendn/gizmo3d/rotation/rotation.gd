extends Gizmo
class_name RotationGizmo

@export var rotate_cw: Shortcut
@export var rotate_ccw: Shortcut

func _input(event: InputEvent) -> void:
	if rotate_cw.matches_event(event) and event.is_pressed():
		rotated.emit(Vector3(0, PI/2, 0))
		finalize.emit()
	elif rotate_ccw.matches_event(event) and event.is_pressed():
		rotated.emit(Vector3(0, -(PI/2), 0))
		finalize.emit()
