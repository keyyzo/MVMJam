class_name Bullet

extends RigidBody3D

var shoot : bool = false

@export var BULLET_SPEED : float = 10.0
@export var BULLET_DAMAGE : float = 20.0

#func _ready() -> void:
	#set_as_top_level(true)
#
#func _physics_process(delta: float) -> void:
	#if shoot:
		#apply_impulse(-transform.basis.z, -transform.basis.z * BULLET_SPEED)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.health -= BULLET_DAMAGE
		queue_free()
	else:
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
