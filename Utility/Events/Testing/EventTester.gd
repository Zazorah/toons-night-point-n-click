extends Node2D

func _ready() -> void:
	EventManager.add_events([
		EventShowMessage.new("This is a test of the event system.", 5.0),
		EventShowMessage.new("You should see a number of events happening in sequence!", 5.0),
		EventShowMessage.new("You should even be able to click through them faster using your mouse!", 5.0)
	])
	
	await get_tree().create_timer(1.0).timeout
	
	EventManager.add_events([
		EventShowMessage.new("I'm even testing adding messages to the queue while it is executing!", 5.0),
		EventShowMessage.new("It's all pretty heady stuff I must be honest.", 5.0),
		EventShowMessage.new("I hope I can work on something visually cool to show to the team after this!", 5.0)
	])
	
	await get_tree().create_timer(5.0).timeout
	
	EventManager.clear_sequence()
	print("SEQUENCE CLEARED!!")
