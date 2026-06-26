class_name InputController extends Node

signal MovementDestination(pos: Vector3)

@export_category("Required Scene")
@export var camera: Camera3D

@onready var _viewport: Viewport = get_viewport()
@onready var _space_state: PhysicsDirectSpaceState3D = get_tree().current_scene.get_world_3d().direct_space_state

const RAY_LENGHT: float = 1000.0

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"MovementDestination"):
		var mouse_position: Vector2 = _viewport.get_mouse_position()

		var ray_origin: Vector3 = camera.project_ray_origin(mouse_position)
		var ray_end: Vector3 = camera.project_ray_normal(mouse_position) * RAY_LENGHT
		var ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		#ray_query.collision_mask = 0b00000000_00000000_00000000_00000001
		
		var query_result: Dictionary = _space_state.intersect_ray(ray_query)
		if query_result:
			MovementDestination.emit(query_result.position)
	
