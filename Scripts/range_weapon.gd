class_name RangeWeapon

extends Node3D

@export var WEAPON_MUZZLE : Marker3D
@onready var WEAPON_BULLET = preload("res://Scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack():
	if Global.player.AIM_FROM_CAMERA.is_colliding():
		var bullet = WEAPON_BULLET.instantiate()
		WEAPON_MUZZLE.add_child(bullet)
		bullet.look_at(Global.player.AIM_FROM_CAMERA.get_collision_point(), Vector3.UP)
		bullet.shoot = true
		
		var RayOrigin = Global.player.CAMERA_CONTROLLER.project_ray_origin(get_viewport().size / 2)
		var RayEnd = (RayOrigin + Global.player.CAMERA_CONTROLLER.project_ray_normal(get_viewport().size / 2) * 500)
		
		var space_state = get_world_3d().get_direct_space_state()
		var params = PhysicsRayQueryParameters3D.create(RayOrigin,RayEnd)
		var intersection = space_state.intersect_ray(params)
		
		# come back to it later
		#if not intersection.is_empty(): 
			#var ColPoint = intersection.
