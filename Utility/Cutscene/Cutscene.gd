class_name Cutscene
extends Resource

@export var steps: Array[CutsceneStep]

# Play a cutscene.
# Creates a Event out of each part of the cutscene and then executes them in sequence.
func play() -> void:
	var _events: Array[Event] = []
	
	_events.push_back(EventOpenDialog.new()) # Open the dialog.
	
	for cutscene_step in steps: # Pass each line to the cutscene player.
		_events.push_back(EventShowDialogLine.new(cutscene_step))
	
	_events.push_back(EventCloseDialog.new()) # Close the dialog.
	
	EventManager.add_events(_events)
