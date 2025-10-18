extends Node

## Global for managing Event sequencing.

signal sequence_started
signal sequence_ended
signal sequence_cancelled

## State
var current_event: Event
var sequence: Array[Event] = []
var currently_executing: bool = false

## Global-entry point for adding events to the queue.
func add_events(events: Array[Event]) -> void:
	for event in events:
		sequence.push_back(event)
	
	if not currently_executing:
		_execute_events()

## Skip the current event. Returns true if successful, false otherwise.
func skip_event() -> bool:
	if current_event and current_event.is_cancellable():
		current_event.is_cancelled = true
		_execute_events()
		return true
		
	return false

func clear_sequence() -> void:
	sequence = []
	sequence_cancelled.emit()

## Reccursively execute all events in sequence.
func _execute_events() -> void:
	currently_executing = true
	
	sequence_started.emit()
	
	if sequence.size() > 0:
		current_event = sequence.pop_front()
		sequence_cancelled.connect(current_event._on_sequence_cancelled, CONNECT_ONE_SHOT)
		
		await current_event.execute(get_tree())
		
		_execute_events() # Continue loop until there are none left.
	else:
		current_event = null
		sequence_ended.emit()
		currently_executing = false
