extends Timer



# preloaded classes


# consts
const NyctophobiaAttackStartDelay_s    : int   = 10
const InvisibleVignetteMultiplier      : float = 1.0
const VisibleVignetteMultiplier        : float = -0.6
const NyctophobiaEffectReductionTime_s : int   = 3


# members
var timeRanOut  : bool  = false
var vignetteElapsedTime_s : float = 0.0
var nyctophobiaReductionElapsedTime_s : float = 0.0


# nodes
onready var Flashlight = get_node("../Flashlight")
onready var VignetteShader = $VignetteShader/CanvasLayer/ColorRect


func _ready() -> void:
	set_autostart(true)
	set_one_shot(true)
	set_wait_time(NyctophobiaAttackStartDelay_s)
	
	setVignetteVisibilityMultiplier(InvisibleVignetteMultiplier)


func _process(delta : float) -> void:
	if (timeRanOut):
		return
	
	#print("left time ", get_time_left())
	setUpNyctophobiaAttackTimer(delta)
	setUpVignetteVisibility(delta)
	
	print(nyctophobiaReductionElapsedTime_s, " ", getVignetteVisibilityMultiplier())
	
	if (is_stopped()):
		timeRanOut = true
		print("Emily has got a nyctophobia attack!")
		get_tree().change_scene("res://src/ui/screens/game-over/GameOverScreen.tscn")




func setUpNyctophobiaAttackTimer(delta : float) -> void:
	if (Flashlight.isTurnedOn):
		nyctophobiaReductionElapsedTime_s += delta
		set_paused(true)
	elif (is_paused()):
		set_paused(false)
		start(NyctophobiaAttackStartDelay_s)
	
	if (not Flashlight.isTurnedOn):
		nyctophobiaReductionElapsedTime_s = 0.0


func setUpVignetteVisibility(delta : float) -> void:
	if (Flashlight.isTurnedOn and nyctophobiaReductionElapsedTime_s >= NyctophobiaEffectReductionTime_s):
		vignetteElapsedTime_s = 0.0
		setVignetteVisibilityMultiplier(InvisibleVignetteMultiplier)
	elif (not Flashlight.isTurnedOn):
		var newMultiplier = lerp(InvisibleVignetteMultiplier, VisibleVignetteMultiplier, min(1, vignetteElapsedTime_s / NyctophobiaAttackStartDelay_s))
		vignetteElapsedTime_s += delta
		setVignetteVisibilityMultiplier(newMultiplier)


func getVignetteVisibilityMultiplier() -> float:
	return VignetteShader.get_material().get_shader_param("multiplier")


func setVignetteVisibilityMultiplier(value : float) -> void:
	VignetteShader.get_material().set_shader_param("multiplier", value)
