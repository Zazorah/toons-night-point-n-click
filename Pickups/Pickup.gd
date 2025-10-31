class_name Pickup
extends Character

## Item Properties
@export var item_key: StringName = "Flower"
@export var item_quantity: int = 1

## Cutscene Properties
@export var pre_cutscene: Cutscene # Cutscene that plays before pickup.
@export var post_cutscene: Cutscene # Cutscene that plays after pickup.

@onready var pickup_id = _generate_pickup_id()
@onready var clickable_area = $ClickableArea

func _ready() -> void:
	# Check collection status.
	print(pickup_id)
	
	add_to_group("Interactables")

func _generate_pickup_id() -> StringName:
	# Get Relevant Information
	var pos_x = global_position.x
	var pos_y = global_position.y
	
	return "_".join([item_key, pos_x, pos_y])

func on_click() -> void:
	var events: Array[Event] = [
		EventPlayerApproachCharacter.new(self)
	]
	
	if pre_cutscene:
		for event in pre_cutscene.generate_events():
			events.push_back(event)
	
	if item_key:
		events.push_back(EventGiveItem.new(item_key, item_quantity))
		events.push_back(EventClearPickup.new(self))
	
	if post_cutscene:
		for event in post_cutscene.generate_events():
			events.push_back(event)
	
	EventManager.add_events(events)
