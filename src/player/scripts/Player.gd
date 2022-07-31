extends KinematicBody2D

# preloaded classes
const CharacterMovingEnv = preload("res://src/player/scripts/class-names/CharacterMovingEnv.gd")


# members
var velocity : Vector2 = Vector2.ZERO
var stamina  : float   = CharacterMovingEnv.MaxStamina


# animation
onready var animationPlayer = $AnimationPlayer
onready var animationTree   = $AnimationTree
onready var animationState  = animationTree.get("parameters/playback")


func _ready():
	pass # Replace with function body.


func _process(delta):
	processMoving(delta)



func walk(inputVector, delta):
	animationTree.set("parameters/Walk/blend_position", inputVector)
	animationState.travel("Walk")
	velocity = velocity.move_toward(inputVector * CharacterMovingEnv.WalkSpeed, CharacterMovingEnv.WalkAcceleration * delta)


func run(inputVector, delta):
	var ableToRun = true
	var staminaLoss = CharacterMovingEnv.StaminaConsumptionCoef * delta

	if (stamina - staminaLoss >= 0):
		stamina -= staminaLoss
		animationTree.set("parameters/Run/blend_position", inputVector)
		animationState.travel("Run")
		velocity = velocity.move_toward(inputVector * CharacterMovingEnv.RunSpeed, CharacterMovingEnv.RunAcceleration * delta)
	else:
		ableToRun = false

	return ableToRun


func recoverStamina(delta):
	stamina += CharacterMovingEnv.StaminaRecoveryUnit * delta
	stamina = min(stamina, CharacterMovingEnv.MaxStamina)


func processMoving(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up")

	inputVector = inputVector.normalized()

	var isRunningActionActive = false
	
	if (inputVector != Vector2.ZERO):
		animationTree.set("parameters/Idle/blend_position", inputVector)

		isRunningActionActive = Input.is_action_pressed("ui_run")
		var isAbleToRun = true

		if (isRunningActionActive):
			isAbleToRun = run(inputVector, delta)

		if (!isRunningActionActive or !isAbleToRun):
			walk(inputVector, delta)

	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, CharacterMovingEnv.Friction * delta)

	# if not trying to run then recover stamina
	if (!isRunningActionActive):
		recoverStamina(delta)

	print(stamina)
	velocity = move_and_slide(velocity)
