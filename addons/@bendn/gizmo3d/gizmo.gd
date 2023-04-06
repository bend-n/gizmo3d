extends Node3D
class_name Gizmo

## A 3D Gizmo, doesn't directly move objects, instead emits signals.
## Thereby allowing you to do anything, including use the [UndoRedo] system,
## without being constrained by defaults.

## Emitted when this gizmo is clicked.
signal clicked
## Gizmo was rotated by [param change].
signal rotated(change: Vector3)
## Gizmo was translated by [param offset].
signal displaced(offset: Vector3)
## Gizmo scaled by [param change].
signal scaled(change: Vector3)
## Gizmo finished moving, lock it in.
signal finalize

## I couldn't get [member BaseMaterial3D.fixed_size] to work soooo.
@export_exp_easing("attenuation") var scale_multiplier := 0.00011

@onready var _camera := get_viewport().get_camera_3d()

func _physics_process(_delta: float) -> void:
	_update_scale()

func _update_scale():
	var distance := (_camera.global_position - global_position).length()
	var size := distance * .00011 * _camera.fov
	scale = size * Vector3.ONE

func _ready() -> void:
	_update_scale()
	for c in get_children():
		if c.has_signal(&"clicked"):
			c.clicked.connect(emit_signal.bind(&"clicked"))
