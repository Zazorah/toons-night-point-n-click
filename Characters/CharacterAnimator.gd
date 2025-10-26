class_name CharacterAnimator
extends AnimatedSprite2D

## Animator for a Character.
## Handles the direction casting for animations whenever play() is called.
## Essentially a state machine for toons.

@export var fallback_animation: StringName = "idle_S"

@onready var character: Character = get_parent() as Character

var animation_state: String = "idle"
var direction: Character.Direction

func _ready() -> void:
	if not character:
		push_error("CharacterAnimator must be a child of a Character node.")
		return
	
	# Connect to Character signals.
	character.direction_changed.connect(_on_direction_changed)

func _on_direction_changed(new_direction: Character.Direction) -> void:
	direction = new_direction
	play_directional() # Update the currently playing animation.

func set_state(state_name: StringName) -> void:
	animation_state = state_name
	play_directional() # Update the currently playing animation.

func play_directional(custom_speed: float = 1.0, from_end: bool = false):
	var directional_name = animation_state + _direction_to_suffix(direction)
	
	if _play_animation(directional_name, custom_speed, from_end):
		return true
	else:
		push_warning("Could not find animation of name ", directional_name, ". Attempting fallback.")
		
		var fallback_direction = _get_fallback_direction(direction)
		if fallback_direction != direction:
			var fallback_directional_name = animation_state + _direction_to_suffix(fallback_direction)
		
			if _play_animation(fallback_directional_name, custom_speed, from_end):
				return true
		
		play(fallback_animation)
		return false

## Tries to play an animation given it's name and returns true or false based on if it was succesful.
func _play_animation(anim_name: StringName, custom_speed: float = 1.0, from_end: bool = false):
	print("Attempting to play animation: " , anim_name)
	if sprite_frames.has_animation(anim_name):
		play(anim_name, custom_speed, from_end)
		return true
	
	return false

## Direction Utility Methods
## -------------------------
func _direction_to_suffix(dir: Character.Direction) -> String:
	match dir:
		Character.Direction.N:
			return "_N"
		Character.Direction.E:
			return "_E"
		Character.Direction.S:
			return "_S"
		Character.Direction.W:
			return "_W"
		Character.Direction.NE:
			return "_NE"
		Character.Direction.NW:
			return "_NW"
		Character.Direction.SE:
			return "_SE"
		Character.Direction.SW:
			return "_SE"
		_:
			push_warning("Something has gone wrong.", direction)
			return ""

func _get_fallback_direction(dir: Character.Direction) -> Character.Direction:
	match dir:
		[Character.Direction.NE, Character.Direction.SE]:
			return Character.Direction.E
		[Character.Direction.NW, Character.Direction.SW]:
			return Character.Direction.W
		_:
			return dir
