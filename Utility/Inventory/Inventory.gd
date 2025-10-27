class_name Inventory
extends RefCounted

## Class representing a Player inventory.

var inventory: Dictionary

## Places the item in the player's inventory.
func give_item(key: StringName, quantity := 1) -> void:
	if inventory.has(key):
		inventory.set(key, inventory.get(key) + quantity)
	else:
		inventory.set(key, quantity)

## Takes the item from a player's inventory if it exists.
func take_item(key: StringName, quantity := 1) -> void:
	if inventory.has(key):
		inventory.set(key, inventory.get(key) - quantity)
		if inventory.get(key) <= 0:
			inventory.erase(key)

## Returns whether the item exists in the player's inventory or not.
func has_item(key: StringName, quantity := 1) -> bool:
	if inventory.has(key):
		return inventory.get(key) >= quantity
	
	return false

## Attempt to spend item. Returns true and removes quantity if successful.
func spend_item(key: StringName, quantity := 1) -> bool:
	if has_item(key, quantity):
		take_item(key, quantity)
		return true
	
	return false

## Returns the inventory as an iterable.
func to_array() -> Array:
	var arr = []
	for key in inventory.keys():
		arr.push_back([
			key, inventory.get(key)
		])
	
	return arr
