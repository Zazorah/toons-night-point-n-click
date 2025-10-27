class_name NPCCharacter
extends Character

## Class representing a non-player character.
## Stands idle.

@export var interactable_size := Vector2(256, 256)
@export var cutscene: Cutscene

var interactable_area: InteractableArea

func _ready() -> void:
	_create_interactable()

func _create_interactable() -> void:
	interactable_area = InteractableArea.new(
		global_position - Vector2(0.0, interactable_size.y/2),
		interactable_size
	)
	
	interactable_area.clicked_on.connect(_on_click)
	
	add_child(interactable_area)

func _on_click() -> void:
	var events: Array[Event] = [
		EventPlayerApproachCharacter.new(self)
	]
	
	if cutscene:
		for event in cutscene.generate_events():
			events.push_back(event)
	
	EventManager.add_events(events)
