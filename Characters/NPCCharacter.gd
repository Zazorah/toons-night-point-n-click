class_name NPCCharacter
extends Character

## Class representing a non-player character.
## Stands idle.

var interactable_area: InteractableArea

func _ready() -> void:
	_create_interactable()

func _create_interactable() -> void:
	interactable_area = InteractableArea.new()
	interactable_area.clicked_on.connect(_on_click)
	
	add_child(interactable_area)

func _on_click() -> void:
	EventManager.add_events([
		EventShowMessage.new("You clicked on me!")
	])
