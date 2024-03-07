class_name WeaponsManager

extends Node3D

@export var WEAPONS_ANIMATIONS : AnimationPlayer 

var current_weapon = null
var weapon_stack : Array = [] # An array of weapons currently held by the player
var weapon_indicator : int = 0
var next_weapon : String
var weapon_list : Dictionary = {}

@export var range_weapon_resources : Array[RangeWeaponResource]
@export var start_weapons : Array[String]

func _ready() -> void:
	pass
	#initialize_weapon(start_weapons)

func _input(event: InputEvent) -> void:
	pass
	# TODO: uncomment the following code once multiple weapons are ready to be used
	# and functionality has been adapted to suit the needs of the game
	
	#if event.is_action_pressed("weapon_up"):
		#weapon_indicator = min(weapon_indicator+1, weapon_stack.size()-1)
		#exit(weapon_stack[weapon_indicator])
		#
	#if event.is_action_pressed("weapon_down"):
		#weapon_indicator = max(weapon_indicator-1, 0)
		#exit(weapon_stack[weapon_indicator])

func initialize_weapon(starting_weapons : Array):
	#creating a dictionary to refer to our weapons
	for weapon in range_weapon_resources:
		weapon_list[weapon.name] = weapon
	
	for i in starting_weapons:
		weapon_stack.push_back(i) # add start weapons
		
	current_weapon = weapon_list[weapon_stack[0]] # set first weapon in stack to current
	
func enter():
	# TODO: add activate weapon animation code here once animation is created
	pass

func exit(swap_weapon : String):
	pass
	# TODO: uncomment the following code once multiple weapons are ready to be used
	# and functionality has been adapted to suit the needs of the game
	#if swap_weapon != current_weapon.name:
		#if WEAPONS_ANIMATIONS.current_animation != current_weapon.deactivate_anim:
			#WEAPONS_ANIMATIONS.play(current_weapon.deativate_anim)
			#next_weapon = swap_weapon
	
func change_weapon(weapon_name : String):
	current_weapon = weapon_list[weapon_name]
	next_weapon = ""
	enter()


func _on_weapon_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == current_weapon.deactivate_anim:
		change_weapon(next_weapon)
		
func shoot():
	pass
