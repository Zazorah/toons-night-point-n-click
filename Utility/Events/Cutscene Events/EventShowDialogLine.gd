class_name EventShowDialogLine
extends Event

## Show a line of dialog in the event queue.

var step: CutsceneStep

func _init(_step: CutsceneStep) -> void:
	step = _step
	
	cancel_behavior = CancelBehavior.UNCANCELLABLE

func execute(_scene_tree: SceneTree) -> void:
	var _player = UIManager.cutscene_player
	
	if _player:
		_player.play_scene_step(step)
		await _player.step_finished
	else:
		push_error("Error: Cutscene Player not set when executing step.")
		await _scene_tree.create_timer(0.1).timeout
