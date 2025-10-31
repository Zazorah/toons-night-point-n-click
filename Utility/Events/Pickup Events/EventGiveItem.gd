class_name EventGiveItem
extends Event

# Place an item in the Player's inventory.

var item_key: StringName
var quantity: int

func _init(new_key: StringName, new_quantity: int) -> void:
	item_key = new_key
	quantity = new_quantity
	
	cancel_behavior = CancelBehavior.UNCANCELLABLE

func execute(_scene_tree: SceneTree) -> void:
	GameManager.inventory.give_item(item_key, quantity)
	print(GameManager.inventory)
	await _scene_tree.create_timer(0.1).timeout
