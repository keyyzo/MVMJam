class_name SprintingPlayerState

extends PlayerMovementState

@export var SPEED : float = 7.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var TOP_ANIM_SPEED : float = 1.6

# Called when the node enters the scene tree for the first time.
func enter(previous_state) -> void:
	ANIMATION.play("Sprinting",0.5,1.0)

func exit() -> void:
	ANIMATION.speed_scale = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	
	set_animation_speed(PLAYER.velocity.length())
	
	if Input.is_action_just_released("sprint") or PLAYER.velocity.length() == 0:
		transition.emit("IdlePlayerState")
		
	if Input.is_action_just_pressed("crouch") and PLAYER.velocity.length() > 6:
		transition.emit("SlidingPlayerState")
		
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")

func set_animation_speed(anim_speed):
	var alpha = remap(anim_speed, 0.0, SPEED,0.0,1.0)
	ANIMATION.speed_scale = lerp(0.0,TOP_ANIM_SPEED, alpha)


