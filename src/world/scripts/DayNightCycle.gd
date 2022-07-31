extends CanvasModulate

const NightColor = Color("#5e5e5e")
const DayColor   = Color("#ffffff")
const TimeScale  = 1 / 5

var time = 0

func _process(delta : float) -> void:
	time += delta * TimeScale
	self.color = NightColor.linear_interpolate(DayColor, abs(sin(time)))
