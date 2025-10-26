extends Node

@export var cutscene: Cutscene

func _ready() -> void:
	cutscene.play()
	
	EventManager.add_events(
		[EventShowMessage.new("The cutscene is done!")]
	)
