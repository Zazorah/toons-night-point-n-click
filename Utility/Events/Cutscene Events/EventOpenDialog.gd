class_name EventOpenDialog
extends Event

func _init() -> void:
	cancel_behavior = CancelBehavior.UNCANCELLABLE

func execute(_scene_tree: SceneTree) -> void:
	UIManager.start_cutscene_player()
	await UIManager.cutscene_player.entered
