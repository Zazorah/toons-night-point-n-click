extends Node

## Manager for UIElement instances.

const CUTSCENE_PLAYER := preload("res://Utility/Cutscene/Player/CutscenePlayer.tscn")
const TRANSITON_PLAYER := preload("res://Utility/Transition Player/TransitionPlayer.tscn")

var ui_root: Control
var ui_layer: CanvasLayer

# Specific UI Nodes
var cutscene_player: CutscenePlayer

func _ready() -> void:
	# Initialize UI Layer
	ui_layer = CanvasLayer.new()
	get_tree().root.add_child.call_deferred(ui_layer)

func process_click(click_context: ClickContext) -> bool:
	for child in ui_layer.get_children():
		if child is UIElement and false: # child.contains_point(click_context.screen_position):
			child.handle_click()
			return true
	
	return false

func start_cutscene_player() -> CutscenePlayer:
	if cutscene_player:
		cutscene_player.queue_free()
	
	cutscene_player = CUTSCENE_PLAYER.instantiate() as CutscenePlayer
	ui_layer.add_child(cutscene_player)
	
	return cutscene_player

func stop_cutscene_player() -> void:
	cutscene_player.do_exit_animation()

func begin_transition() -> TransitionPlayer:
	var trans_player = TRANSITON_PLAYER.instantiate() as TransitionPlayer
	ui_layer.add_child(trans_player)
	
	return trans_player

func _initialize_test_ui() -> void:
	var block = UITestSquare.new()
	ui_root.add_child(block)
