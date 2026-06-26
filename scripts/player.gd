class_name Player extends Node3D

@export_category("Required Scene")
@export var input_controller: InputController

@export_category("Configuration")
@export var speed: float = 5.0
@export var rotation_velocity: float = 10.0
@export var path_height: float = 0.25

@onready var _model: Node3D = $Model
@onready var _nav_agent: NavigationAgent3D = $NavigationAgent

var is_running: bool = false

func _ready() -> void:
	input_controller.MovementDestination.connect(_on_movement_destination)

func _on_movement_destination(pos: Vector3) -> void:
	_nav_agent.target_position = pos

func _physics_process(delta: float) -> void:
	if not _nav_agent.is_navigation_finished():
		is_running = true
		var destination: Vector3 = _nav_agent.get_next_path_position()
		
		var direction: Vector3 = destination.direction_to(global_position)
		_model.global_rotation.y = lerp_angle(_model.global_rotation.y, atan2(direction.x, direction.z) + PI, rotation_velocity * delta)
				
		global_position = global_position.move_toward(destination, speed * delta)
		_model.global_position = global_position - Vector3(0.0, path_height, 0.0)
		
	else:
		is_running = false
