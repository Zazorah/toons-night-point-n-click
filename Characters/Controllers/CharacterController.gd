@abstract
class_name CharacterController
extends Node

## Class representing the 'brain' of a Character.
## Essentially encapsulates standard state-machine capabilities for a character.

@abstract
func on_create() -> void

@abstract
func on_update(delta: float) -> void

@abstract
func on_destroy() -> void
