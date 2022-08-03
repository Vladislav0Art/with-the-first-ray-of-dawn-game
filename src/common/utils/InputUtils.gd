extends Node

class_name InputUtils


static func getMovingDirection() -> Vector2:
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up")

	return inputVector.normalized()


static func isRunningActionActive() -> bool:
	return Input.is_action_pressed("ui_run")


static func isLightingActionRequested() -> bool:
	return Input.is_action_just_pressed("ui_toggle_lighting")
