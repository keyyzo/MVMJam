extends CharacterBody3D

# Player movement variables
@export var base_walk_speed : float = 5.0
@export var base_jump_velocity : float = 4.5

# Camera variables
@export var camera_sens_y : float = 0.01
@export var camera_sens_x : float = 0.01
@export var angleForCamToLerpTo : float = 0.0
@export var XangleForCamToLerpTo : float = 0.0

# Dash upgrade variables
@export var dash_speed : float = 20.0
@export var dash_upward_speed : float = 5.0
@export var dash_duration : float = 0.25
@export var num_of_dashes_available : int = 1
@export var dash_reset_timer : float = 3.0
var dash_cooldown
var can_dash : bool = true
var is_dashing : bool = false
var dash_direction : Vector3 = Vector3.ZERO
var extra_velocity := Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


# Preset Node variables for use
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var front_raycast := $Neck/Camera3D/FrontRaycast
@onready var joint := $Neck/Camera3D/Generic6DOFJoint3D
@onready var staticbody_for_joint := $Neck/Camera3D/StaticBody3D
@onready var weapon_position := $Neck/Camera3D/WeaponPosition
@onready var aim_reach := $Neck/Camera3D/AimReach

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * camera_sens_y)
			camera.rotate_x(-event.relative.y * camera_sens_x)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = base_jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * base_walk_speed
		velocity.z = direction.z * base_walk_speed
		
		#if Input.is_action_just_pressed("dash") and can_dash and is_dashing == false:
			#is_dashing = true
			#dash()
		
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, base_walk_speed)
		velocity.z = move_toward(velocity.z, 0, base_walk_speed)
		
	if Input.is_action_just_pressed("dash"):
			is_dashing = true
			dash()
			
	extra_velocity = lerp(extra_velocity, Vector3.ZERO, 0.1)
	
	velocity.y = velocity.y
	
	velocity += extra_velocity
	
	
	
	

	move_and_slide()

func jump():
	pass
	
func dash():
	#var force_to_apply = -neck.transform.basis.z * dash_speed + neck.transform.basis.y * dash_upward_speed
	#velocity += force_to_apply
	#is_dashing = false
	
	extra_velocity += ($Neck/Camera3D/AimReach.global_transform.origin - $Neck/Camera3D.global_transform.origin).normalized() * dash_speed
	
	
func reset_dash():
	pass
	
	
