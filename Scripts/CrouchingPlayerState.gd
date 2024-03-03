class_name CrouchingPlayerState

extends PlayerMovementState

@export var SPEED : float = 2.5
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export_range(1,6,0.1) var CROUCH_SPEED : float = 4.0

@onready var CROUCH_SHAPECAST : ShapeCast3D = %ShapeCast3D

var 	RELEASED : bool = false

func enter(previous_state) -> void:
	ANIMATION.speed_scale = 1.0
	if previous_state.name != "SlidingPlayerState":
		ANIMATION.play("Crouch", -1.0, CROUCH_SPEED)
	elif previous_state.name == "SlidingPlayerState":
		ANIMATION.current_animation = "Crouch"
		ANIMATION.seek(1.0, true)
	
func exit() -> void:
	RELEASED = false
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_released("crouch"):
		uncrouch()
	elif Input.is_action_pressed("crouch") == false and RELEASED == false:
		RELEASED = true
		uncrouch()
	
	attack()
		
func uncrouch():
	if CROUCH_SHAPECAST.is_colliding() == false and Input.is_action_pressed("crouch") == false:
		ANIMATION.play("Crouch", -1.0, -CROUCH_SPEED, true)
		if ANIMATION.is_playing():
			await ANIMATION.animation_finished
		transition.emit("IdlePlayerState")
	elif CROUCH_SHAPECAST.is_colliding() == true:
		await get_tree().create_timer(0.1).timeout
		uncrouch()
		

		
func attack():
	if Input.is_action_pressed("attack"):
		if PLAYER.WEAPON_RIG.get_child(0).is_in_group("melee"):
			if !PLAYER.WEAPON_ANIMATION_PLAYER.is_playing():
				PLAYER.WEAPON_ANIMATION_PLAYER.play("MeleeAttack")
				print("attacking")
