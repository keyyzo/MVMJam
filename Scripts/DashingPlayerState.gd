class_name DashingPlayerState

extends PlayerMovementState

@export var SPEED : float = 300.0
@export var ACCELERATION : float = 0.2
@export var DECELERATION : float = 0.1
@export var DASH_COOLDOWN : float = 0.85
var DASHING : bool = false


func enter(previous_state) -> void:
	DASHING = true
	PLAYER.velocity.y = 0.0
	ANIMATION.play("Dashing")
	PLAYER.NUMBER_OF_DASHES -= 1
	
func exit() -> void:
	DASHING = false
	regain_dash()
	
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	#if PLAYER.velocity.length() < 10.0:
		#transition.emit("IdlePlayerState")
	
	if ANIMATION.animation_finished:
		transition.emit("IdlePlayerState")
		
	attack()

func regain_dash():
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	PLAYER.NUMBER_OF_DASHES += 1

func attack():
	if Input.is_action_pressed("attack"):
		if PLAYER.WEAPON_RIG.get_child(0).is_in_group("melee"):
			if !PLAYER.WEAPON_ANIMATION_PLAYER.is_playing():
				PLAYER.WEAPON_ANIMATION_PLAYER.play("MeleeAttack")
				print("attacking")
	
