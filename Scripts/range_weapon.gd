class_name RangeWeapon

extends Node3D

@export var WEAPON_MUZZLE : Marker3D
@onready var WEAPON_BULLET = preload("res://Scenes/bullet.tscn")
@export var WEAPON_RANGE : float = 300.0

var collision_exlusion = []

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
			
func attack_v2():
	var camera_collision = get_camera_collision()
	launch_projectile(camera_collision)

func get_camera_collision():
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport().get_size()
	
	var ray_origin = camera.project_ray_origin(viewport/2)
	var ray_end = ray_origin + camera.project_ray_normal(viewport/2) * WEAPON_RANGE
	
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin,ray_end)
	new_intersection.set_exclude(collision_exlusion)
	
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if not intersection.is_empty():
		var col_point = intersection.position
		return col_point
	else:
		return ray_end
		
func launch_projectile(collision_point : Vector3):
	var direction = (collision_point - WEAPON_MUZZLE.get_global_transform().origin).normalized()
	var projectile = WEAPON_BULLET.instantiate()
	
	var projectile_rid = projectile.get_rid()
	collision_exlusion.push_front(projectile_rid)
	projectile.tree_exited.connect(remove_exclusion.bind(projectile.get_rid()))
	
	WEAPON_MUZZLE.add_child(projectile)
	projectile.set_linear_velocity(direction * projectile.BULLET_SPEED)
	
func remove_exclusion(projectile_rid):
	collision_exlusion.erase(projectile_rid)
