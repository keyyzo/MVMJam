@tool

extends Sprite3D

@export var MELEE_WEAPON_TYPE : MeleeWeapons:
	set(value):
		MELEE_WEAPON_TYPE = value
		if Engine.is_editor_hint():
			load_weapon()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_weapon()
	
func load_weapon():
	texture = MELEE_WEAPON_TYPE.texture
	position = MELEE_WEAPON_TYPE.position
	rotation_degrees = MELEE_WEAPON_TYPE.rotation
	
