class_name EventClearPickup
extends Event

# Removes a Pickup from a room and logs it's collection status in State.

var pickup: Pickup

func _init(new_pickup: Pickup) -> void:
	pickup = new_pickup
	
	cancel_behavior = CancelBehavior.UNCANCELLABLE

func execute(_scene_tree: SceneTree) -> void:
	# Store collection data.
	GameManager.register_pickup_status(pickup.pickup_id)
	
	# Remove from Scene.
	pickup.queue_free()
	
	print(GameManager.pickup_collection_status)
	
	await _scene_tree.create_timer(0.1).timeout
