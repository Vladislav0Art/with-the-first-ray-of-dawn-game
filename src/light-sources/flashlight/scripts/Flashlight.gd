extends Node2D


# preloaded classes
const MoveDirections = preload("res://src/common/enums/MoveDirections.gd")


# consts


# members
var previousDirection : int = MoveDirections.__None__


# child nodes
#onready var FlashlightCone = $FlashlightCone


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
		#print(flashlightAngle)
