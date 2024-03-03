class_name Player

extends CharacterBody3D

# General character variables

@export var SPEED_DEFAULT : float = 5.0
@export var SPEED_WHILE_CROUCH : float = 2.5
@export var SPEED_WHILE_SPRINT : float = 7.0
@export var JUMP_VELOCITY : float = 4.5
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var GRAVITY : float = 12.0

@export var ANIMATION_PLAYER : AnimationPlayer
@export var WEAPON_ANIMATION_PLAYER : AnimationPlayer

var player_speed : float

# Player weapon variables

@onready var WEAPON_RIG : Node3D = %WeaponRig

# Dash variables to be used within the DashingPlayerState
# May adapt this usage to a resource file but need to understand it more first

@export var NUMBER_OF_DASHES : int = 2
var reset_dash_timer : Timer
@export var have_dash_ability : bool = true
var can_dash : bool = true

# Camera variables

@export var MOUSE_SENS : float = 0.02
@export var TILT_LOWER_LIMIT := deg_to_rad(-90)
@export var TILT_UPPER_LIMIT := deg_to_rad(90)
@export var CAMERA_CONTROLLER : Camera3D


var mouse_input : bool = false
var mouse_rotation : Vector3
var rotation_input : float
var tilt_input : float
var player_rotation : Vector3
var camera_rotation : Vector3
var current_rotation : float

# Crouch variables - deprecated

var is_crouching : bool = false
#@export_range(5,10,0.1) var CROUCH_SPEED : float = 7.0
@export var CROUCH_SHAPECAST : Node3D
#@export var TOGGLE_CROUCH : bool = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
		
		
func _unhandled_input(event: InputEvent) -> void:
	mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if mouse_input:
		rotation_input = -event.relative.x * MOUSE_SENS
		tilt_input = -event.relative.y * MOUSE_SENS
		
func update_camera(delta):
	# Rotate camera using eular rotation
	
	current_rotation = rotation_input
	mouse_rotation.x += tilt_input * delta
	mouse_rotation.x = clamp(mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	mouse_rotation.y += rotation_input * delta
	
	player_rotation = Vector3(0.0, mouse_rotation.y, 0.0)
	camera_rotation = Vector3(mouse_rotation.x, 0.0,0.0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(player_rotation)
	
	rotation_input = 0.0
	tilt_input = 0.0

func _ready() -> void:
	
	Global.player = self
	
	# Mouse input
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Default speed
	player_speed = SPEED_DEFAULT
	
	# Crouch check shapecast collision exception
	CROUCH_SHAPECAST.add_exception($".") 

func _physics_process(delta: float) -> void:
	
	Global.debug.add_property("MovementSpeed",player_speed, 1)
	Global.debug.add_property("MouseRotation", mouse_rotation, 2)
	
	update_camera(delta)

func update_gravity(delta) -> void:
	velocity.y -= GRAVITY * delta
	
func update_input(speed: float, acceleration : float, deceleration : float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		
		velocity.x = lerp(velocity.x, direction.x * speed, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * speed, ACCELERATION)
		
	else:
		var vel = Vector2(velocity.x,velocity.z)
		var temp = move_toward(Vector2(velocity.x, velocity.z).length(), 0, DECELERATION)
		velocity.x = vel.normalized().x * temp
		velocity.z = vel.normalized().y * temp
	
func update_velocity() -> void:
	move_and_slide()
