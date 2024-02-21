class_name SprintingPlayerState

extends State

@export var ANIMATION : AnimationPlayer
@export var TOP_ANIM_SPEED : float = 1.6

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	ANIMATION.play("Sprinting",0.5,1.0)
	Global.player.speed = Global.player.SPEED_WHILE_SPRINT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	set_animation_speed(Global.player.velocity.length())
	

func set_animation_speed(anim_speed):
	var alpha = remap(anim_speed, 0.0, Global.player.SPEED_WHILE_SPRINT,0.0,1.0)
	ANIMATION.speed_scale = lerp(0.0,TOP_ANIM_SPEED, alpha)

func _input(event: InputEvent) -> void:
	if event.is_action_released("sprint"):
		transition.emit("WalkingPlayerState")
