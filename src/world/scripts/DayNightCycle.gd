extends CanvasModulate


# preloaded classes


# consts
const NightColor        : Color = Color("#3e3e3e")
const DayColor          : Color = Color("#ffffff")
const GameSessionTime_s : int   = 20


# members
var time = 0


# nodes



func _process(delta : float) -> void:
	time += delta
	
	var interpolationWeight = sin(min(time / GameSessionTime_s, 1) * PI / 2)
	self.color = NightColor.linear_interpolate(DayColor, interpolationWeight) # abs(sin(time)
