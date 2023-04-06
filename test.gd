extends Node3D

var current: Gizmo
var gizmo_holder := Node3D.new()

var original_gh_p: Vector3
var original_positions: PackedVector3Array = []
var original_rotations: PackedVector3Array = []
var original_scales: PackedVector3Array = []

@export var target: Node3D
@export var gizmo: PackedScene
@onready var targets: Array[Node3D] = [target]

func _ready() -> void:
	add_child(gizmo_holder)
	current = gizmo.instantiate()
	_position_gizmo_holder()
	gizmo_holder.add_child(current)
	_setup_originals()
	current.finalize.connect(_gizmo_finalize)
	current.displaced.connect(_gizmo_displace)
	current.scaled.connect(_gizmo_scale)
	current.rotated.connect(_gizmo_rotate)

func _position_gizmo_holder() -> void:
	var sum := Vector3.ZERO
	for node in targets:
		sum += node.global_position
	gizmo_holder.global_position = sum / len(targets)

func _setup_originals() -> void:
	original_positions.resize(len(targets))
	original_rotations.resize(len(targets))
	original_scales.resize(len(targets))
	for i in len(targets):
		var n := targets[i]
		original_positions[i] = n.global_position
		original_rotations[i] = n.global_rotation
		original_scales[i] = n.scale
	original_gh_p = gizmo_holder.global_position

func _gizmo_displace(offset: Vector3):
	for i in len(targets):
		targets[i].global_position = original_positions[i] + offset
	gizmo_holder.global_position = original_gh_p + offset

func _gizmo_scale(change: Vector3):
	for i in len(targets):
		var n := targets[i]
		var scl := original_scales[i] + change
		if scl.x <= 0 || scl.y <= 0: # no flipping allowed
			scl = Vector3.ONE
		n.scale = scl

func _gizmo_rotate(change: Vector3):
	for i in len(targets):
		var n := targets[i]
		n.global_rotation = original_rotations[i] + change

func _gizmo_finalize():
	for i in len(targets):
		var n := targets[i]
		original_positions[i] = n.global_position
		original_scales[i] = n.scale
		original_rotations[i] = n.global_rotation
	original_gh_p = gizmo_holder.global_position
