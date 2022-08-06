extends Timer



# preloaded classes


# consts
const NyctophobiaAttackStartDelay_s      : int   = 10
const InvisibleVignetteMultiplier        : float = 1.0
const VisibleVignetteMultiplier          : float = -0.6


# members
var timeRanOut  : bool  = false
var elapsedTime : float = 0.0


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
	setUpNyctophobiaAttackTimer()
	setUpVignetteVisibility(delta)
	
	if (is_stopped()):
		timeRanOut = true
		print("Emily has got a nyctophobia attack!")
		get_tree().change_scene("res://src/ui/screens/game-over/GameOverScreen.tscn")


	
	


func setUpNyctophobiaAttackTimer() -> void:
	if (Flashlight.isTurnedOn):
		set_paused(true)
	elif (is_paused()):
		set_paused(false)
		start(NyctophobiaAttackStartDelay_s)


func setUpVignetteVisibility(delta : float) -> void:
	if (Flashlight.isTurnedOn):
		elapsedTime = 0.0
		setVignetteVisibilityMultiplier(InvisibleVignetteMultiplier)
	else:
		#print(getVignetteVisibilityMultiplier())
		var newMultiplier = lerp(InvisibleVignetteMultiplier, VisibleVignetteMultiplier, min(1, elapsedTime / NyctophobiaAttackStartDelay_s))
		elapsedTime += delta
		setVignetteVisibilityMultiplier(newMultiplier)


func getVignetteVisibilityMultiplier() -> float:
	return VignetteShader.get_material().get_shader_param("multiplier")


func setVignetteVisibilityMultiplier(value : float) -> void:
	VignetteShader.get_material().set_shader_param("multiplier", value)
