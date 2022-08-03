extends Timer



# preloaded classes


# consts
const  NyctophobiaAttackStartDelay_s : int = 10


# members
var timeRanOut : bool = false


# nodes
onready var Flashlight = get_node("../Flashlight")



func _ready() -> void:
	set_autostart(true)
	set_one_shot(true)
	set_wait_time(NyctophobiaAttackStartDelay_s)


func _process(_delta : float) -> void:
	if (timeRanOut):
		return
	
	#print(get_time_left())
	
	if (Flashlight.isTurnedOn):
		set_paused(true)
	elif (is_paused()):
		set_paused(false)
		start(NyctophobiaAttackStartDelay_s)
	
	if (is_stopped()):
		timeRanOut = true
		print("Emily has got a nyctophobia attack!")
