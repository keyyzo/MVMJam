class_name WeaponsManager

extends Node3D

@export var WEAPONS_ANIMATIONS : AnimationPlayer 

var current_weapon = null
var weapon_stack : Array = [] # An array of weapons currently held by the player
var weapon_indicator : int = 0
var next_weapon : String
var weapon_list : Dictionary = {}

@export var range_weapon_resources : Array[RangeWeaponResource]
@export var start_weapons : Array[String]
@export var muzzle : Marker3D

var collision_exlusion = []

func _ready() -> void:
	pass
	#initialize_weapon(start_weapons)

func _input(event: InputEvent) -> void:
	pass
	# TODO: uncomment the following code once multiple weapons are ready to be used
	# and functionality has been adapted to suit the needs of the game
	
	#if event.is_action_pressed("weapon_up"):
		#weapon_indicator = min(weapon_indicator+1, weapon_stack.size()-1)
		#exit(weapon_stack[weapon_indicator])
		#
	#if event.is_action_pressed("weapon_down"):
		#weapon_indicator = max(weapon_indicator-1, 0)
		#exit(weapon_stack[weapon_indicator])
		
	#if event.is_action_pressed("attack"):
		#shoot()

func initialize_weapon(starting_weapons : Array):
	#creating a dictionary to refer to our weapons
	for weapon in range_weapon_resources:
		weapon_list[weapon.name] = weapon
	
	for i in starting_weapons:
		weapon_stack.push_back(i) # add start weapons
		
	current_weapon = weapon_list[weapon_stack[0]] # set first weapon in stack to current
	
func enter():
	# TODO: add activate weapon animation code here once animation is created
	pass

func exit(swap_weapon : String):
	pass
	# TODO: uncomment the following code once multiple weapons are ready to be used
	# and functionality has been adapted to suit the needs of the game
	#if swap_weapon != current_weapon.name:
		#if WEAPONS_ANIMATIONS.current_animation != current_weapon.deactivate_anim:
			#WEAPONS_ANIMATIONS.play(current_weapon.deativate_anim)
			#next_weapon = swap_weapon
	
func change_weapon(weapon_name : String):
	current_weapon = weapon_list[weapon_name]
	next_weapon = ""
	enter()


func _on_weapon_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == current_weapon.deactivate_anim:
		change_weapon(next_weapon)
		
func shoot():
	var camera_collision = get_camera_collision()
	
	
func get_camera_collision():
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport().get_size()
	
	var ray_origin = camera.project_ray_origin(viewport/2)
	var ray_end = ray_origin + camera.project_ray_normal(viewport/2)*current_weapon.weapon_range
	
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin,ray_end)
	new_intersection.set_exclude(collision_exlusion)
	
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if not intersection.is_empty():
		var col_point = intersection.position
		return col_point
	else:
		return ray_end
		
func hit_scan_collision(collision_point):
	var bullet_direction = (collision_point - muzzle.get_global_transform().origin).normalized()
	var new_intersection = PhysicsRayQueryParameters3D.create(muzzle.get_global_transform().origin,collision_point+bullet_direction*2)
	
	var bullet_collision = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if bullet_collision:
		print("Hit scan damage")
		
func launch_projectile(collision_point : Vector3):
	var direction = (collision_point - muzzle.get_global_transform().origin).normalized()
	#var projectile = current_weapon.projectile_to_load.instantiate()
	
	#var projectile_rid = projectile.get_rid()
	#collision_exlusion.push_back(projectile_rid)
	#projectile.tree_exited.connect(remove_exclusion.bind(projectile.get_rid())
	
	#muzzle.add_child(projectile)
	#projectile.damage = current_weapon.damage
	#projectile.set_linear_velocity(direction * current_weapon.projectile_velocity)
	
func remove_exclusion(projectile_rid):
	collision_exlusion.erase(projectile_rid)
