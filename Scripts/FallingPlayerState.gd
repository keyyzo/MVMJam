class_name FallingPlayerState

extends PlayerMovementState

@export var SPEED : float = 5.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var DOUBLE_JUMP_VELOCITY : float = 8.0
@export_range(0.5,1.0,0.01) var INPUT_MULTIPLIER : float = 0.85

var DOUBLE_JUMP : bool = false

func enter(previous_state) -> void:
	ANIMATION.pause()
	
	if previous_state.has_method("get_double_jump"):
		print("worked")
		DOUBLE_JUMP = previous_state.get_double_jump()
		
	
func exit() -> void:
	DOUBLE_JUMP = false

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED * INPUT_MULTIPLIER,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed("jump") and DOUBLE_JUMP == false:
		DOUBLE_JUMP = true
		PLAYER.velocity.y = DOUBLE_JUMP_VELOCITY
		
	if Input.is_action_just_pressed("dash") and PLAYER.NUMBER_OF_DASHES > 0:
		transition.emit("DashingPlayerState")
		
	if PLAYER.is_on_floor():
		ANIMATION.play("JumpEnd")
		transition.emit("IdlePlayerState")
		
	attack()
	
func attack():
	if Input.is_action_pressed("attack"):
		if PLAYER.WEAPON_RIG.get_child(0).is_in_group("melee"):
			if !PLAYER.WEAPON_ANIMATION_PLAYER.is_playing():
				PLAYER.WEAPON_ANIMATION_PLAYER.play("MeleeAttack")
				print("attacking")
