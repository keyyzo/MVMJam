class_name JumpingPlayerState

extends PlayerMovementState

@export var SPEED : float = 6.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var JUMP_VELOCITY : float = 8.0
@export var DOUBLE_JUMP_VELOCITY : float = 8.0
@export var RELEASE_JUMP_MULTIPLIER : float = 2.0
@export_range(0.5,1.0,0.01) var INPUT_MULTIPLIER : float = 0.85

var DOUBLE_JUMP : bool = false
var temp_jump : bool

func enter(previous_state) -> void:
	PLAYER.velocity.y += JUMP_VELOCITY
	ANIMATION.play("JumpStart")
	
func exit() -> void:
	set_double_jump(DOUBLE_JUMP)
	DOUBLE_JUMP = false
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED * INPUT_MULTIPLIER,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed("jump") and DOUBLE_JUMP == false:
		DOUBLE_JUMP = true
		PLAYER.velocity.y = DOUBLE_JUMP_VELOCITY
		
	if Input.is_action_just_released("jump"):
		if PLAYER.velocity.y > 0:
			PLAYER.velocity.y = PLAYER.velocity.y / RELEASE_JUMP_MULTIPLIER
			
	if Input.is_action_just_pressed("dash") and PLAYER.NUMBER_OF_DASHES > 0:
		transition.emit("DashingPlayerState")
		
	if PLAYER.velocity.y < -5.0:
		transition.emit("FallingPlayerState")
		
	#if PLAYER.is_on_floor():
		#ANIMATION.play("JumpEnd")
		#await ANIMATION.animation_finished
		#transition.emit("IdlePlayerState")
		
	attack()

func attack():
	if Input.is_action_pressed("attack"):
		if PLAYER.WEAPON_RIG.get_child(0).is_in_group("melee"):
			if !PLAYER.WEAPON_ANIMATION_PLAYER.is_playing():
				PLAYER.WEAPON_ANIMATION_PLAYER.play("MeleeAttack")
				print("attacking")
				
func set_double_jump(jump_status : bool) -> void:
	temp_jump = jump_status

func get_double_jump() -> bool:
	return temp_jump
