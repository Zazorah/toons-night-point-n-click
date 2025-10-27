class_name Cutscene
extends Resource

@export var steps: Array[CutsceneStep]

# Play a cutscene.
# Creates a Event out of each part of the cutscene and then executes them in sequence.
func play() -> void:
	EventManager.add_events(generate_events())

func generate_events() -> Array[Event]:
	var events: Array[Event] = []
	
	events.push_back(EventOpenDialog.new()) # Open the dialog.
	
	for cutscene_step in steps: # Pass each line to the cutscene player.
		events.push_back(EventShowDialogLine.new(cutscene_step))
	
	events.push_back(EventCloseDialog.new()) # Close the dialog.
	
	return events
