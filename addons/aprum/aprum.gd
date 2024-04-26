@tool
extends EditorPlugin

const DISPATCHER_SCRIPT := preload ("scripts/dispatcher.gd")
const DISPATCHER_ICON := preload ("icons/dispatcher.svg")

func _enter_tree() -> void:
	add_custom_type("Dispatcher", "Node", DISPATCHER_SCRIPT, DISPATCHER_ICON)

func _exit_tree() -> void:
	remove_custom_type("Dispatcher")
