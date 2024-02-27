class_name DashingPlayerState

extends PlayerMovementState

@export var SPEED : float = 300.0
@export var ACCELERATION : float = 0.2
@export var DECELERATION : float = 0.1



func enter(previous_state) -> void:
	ANIMATION.play("Dashing")
	
func exit() -> void:
	pass
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	#if PLAYER.velocity.length() < 10.0:
		#transition.emit("IdlePlayerState")
	
	if ANIMATION.animation_finished:
		transition.emit("IdlePlayerState")
