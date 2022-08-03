extends KinematicBody2D


# preloaded classes
const CharacterMovingEnv = preload("res://src/player/scripts/class-names/CharacterMovingEnv.gd")
const InputUtils         = preload("res://src/common/utils/InputUtils.gd")


# members
var velocity : Vector2 = Vector2.ZERO
var stamina  : float   = CharacterMovingEnv.MaxStamina


# nodes


# animation
onready var animationPlayer = $AnimationPlayer
onready var animationTree   = $AnimationTree
onready var animationState  = animationTree.get("parameters/playback")



func _ready() -> void:
	animationTree.active = true


func _process(delta : float) -> void:	
	var movingDirection = InputUtils.getMovingDirection()
	processMoving(movingDirection, delta)


func walk(movingDirection : Vector2, delta : float) -> void:
	animationTree.set("parameters/Walk/blend_position", movingDirection)
	animationState.travel("Walk")
	velocity = velocity.move_toward(movingDirection * CharacterMovingEnv.WalkSpeed, CharacterMovingEnv.WalkAcceleration * delta)


func run(movingDirection : Vector2, delta : float) -> bool:
	var ableToRun = true
	var staminaLoss = CharacterMovingEnv.StaminaConsumptionCoef * delta

	if (stamina - staminaLoss >= 0):
		stamina -= staminaLoss
		animationTree.set("parameters/Run/blend_position", movingDirection)
		animationState.travel("Run")
		velocity = velocity.move_toward(movingDirection * CharacterMovingEnv.RunSpeed, CharacterMovingEnv.RunAcceleration * delta)
	else:
		ableToRun = false

	return ableToRun


func recoverStamina(delta : float) -> void:
	stamina += CharacterMovingEnv.StaminaRecoveryUnit * delta
	stamina = min(stamina, CharacterMovingEnv.MaxStamina)


func processMoving(movingDirection: Vector2, delta : float) -> void:
	var isRunningActionActive = false
	
	if (movingDirection != Vector2.ZERO):
		animationTree.set("parameters/Idle/blend_position", movingDirection)

		isRunningActionActive = InputUtils.isRunningActionActive()#Input.is_action_pressed("ui_run")
		var isAbleToRun = true

		if (isRunningActionActive):
			isAbleToRun = run(movingDirection, delta)

		if (!isRunningActionActive or !isAbleToRun):
			walk(movingDirection, delta)

	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, CharacterMovingEnv.Friction * delta)

	# if not trying to run then recover stamina
	if (!isRunningActionActive):
		recoverStamina(delta)

	velocity = move_and_slide(velocity)
