class_name WalkingPlayerState

extends PlayerMovementState

@export var SPEED : float = 5.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var TOP_ANIM_SPEED : float = 2.2

func enter(previous_state) -> void:
	if ANIMATION.is_playing() and ANIMATION.current_animation == "JumpEnd":
		await ANIMATION.animation_finished
		ANIMATION.play("Walking", -1, 1.0)
	else:
		ANIMATION.play("Walking", -1, 1.0)
	
func exit() -> void:
	ANIMATION.speed_scale = 1.0

func update(delta):

	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.velocity.length())
	
	if Input.is_action_pressed("sprint") and PLAYER.is_on_floor():
		transition.emit("SprintingPlayerState")
		
	if Input.is_action_pressed("crouch") and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
		
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if Input.is_action_just_pressed("dash") and PLAYER.NUMBER_OF_DASHES > 0:
		transition.emit("DashingPlayerState")
	
	if PLAYER.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
		
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
		
	attack()
	

func set_animation_speed(anim_speed):
	var alpha = remap(anim_speed, 0.0, SPEED,0.0,1.0)
	ANIMATION.speed_scale = lerp(0.0,TOP_ANIM_SPEED, alpha)

func attack():
	if Input.is_action_pressed("attack"):
		if PLAYER.WEAPON_RIG.get_child(0).is_in_group("melee"):
			if !PLAYER.WEAPON_ANIMATION_PLAYER.is_playing():
				PLAYER.WEAPON_ANIMATION_PLAYER.play("MeleeAttack")
				print("attacking")
