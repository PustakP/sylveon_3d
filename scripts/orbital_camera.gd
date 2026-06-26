class_name OrbitalCamera extends Node3D

@export_category("Scene")
@export var target_to_follow: Node3D

@export_category("Configuration")
@export var speed: float = 4.0
@export var mouse_sensitivity: float = 0.15

@onready var _spring_arm: SpringArm3D = $SpringArm

const HALF_PI: float = PI / 2.0

var _delta: float = 0.0

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed(&"RotateView") and event is InputEventMouseMotion:
		rotate_y(-event.screen_relative.x * mouse_sensitivity * _delta)
		_spring_arm.rotation.x = clampf(_spring_arm.rotation.x - event.screen_relative.y * mouse_sensitivity * _delta, -1.0, 0.0)

func _physics_process(delta: float) -> void:
	_delta = delta
	
	if target_to_follow:
		if not global_position.is_equal_approx(target_to_follow.global_position):
			global_position = global_position.lerp(target_to_follow.global_position, speed * delta)
