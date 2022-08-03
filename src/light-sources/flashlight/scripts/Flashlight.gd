extends Node2D


# preloaded classes
const MoveDirections = preload("res://src/common/enums/MoveDirections.gd")
const InputUtils     = preload("res://src/common/utils/InputUtils.gd")


# consts
const DefaultFlashlightAngle = deg2rad(90)


# members
var previousDirection : int  = MoveDirections.__None__
var isTurnedOn        : bool = false


# nodes
onready var FlashlightCone = $FlashlightCone



func _ready() -> void:
	set_rotation(DefaultFlashlightAngle)
	FlashlightCone.visible = isTurnedOn


func _process(_delta : float) -> void:
	var movingDirection = InputUtils.getMovingDirection()
	rotateLightCone(movingDirection)
	
	if (InputUtils.isLightingActionRequested()):
		toggleFlashlight()
	

func toggleFlashlight() -> void:
	isTurnedOn = !isTurnedOn
	FlashlightCone.visible = isTurnedOn


func createDirectionMask(direction : Vector2):
	var mask = MoveDirections.__None__
	
	if (direction == Vector2.ZERO):
		return mask
	
	if (direction.x > 0):
		mask |= MoveDirections.Right
	elif (direction.x < 0):
		mask |= MoveDirections.Left
		
	if (direction.y > 0):
		mask |= MoveDirections.Up
	elif (direction.y < 0):
		mask |=MoveDirections.Down
	
	return mask



func rotateLightCone(direction : Vector2) -> void:
	var directionMask = createDirectionMask(direction)
	
	if (directionMask != previousDirection && directionMask != MoveDirections.__None__):
		previousDirection = directionMask

		var flashlightAngle = direction.angle()
		
		# setting direction of Flashlight node point
		set_rotation(flashlightAngle)
