class_name NPCCharacter
extends Character

## Class representing a non-player character.
## Stands idle.

@export var cutscene: Cutscene

@onready var clickable_area: Area2D = $ClickableArea

func _ready() -> void:
	add_to_group("Interactables")

func on_click() -> void:
	var events: Array[Event] = [
		EventPlayerApproachCharacter.new(self)
	]
	
	if cutscene:
		for event in cutscene.generate_events():
			events.push_back(event)
	
	EventManager.add_events(events)
