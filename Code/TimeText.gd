extends PanelContainer

class_name TimeTextPanel

@onready var TimeText:Label = $MarginContainer/Time

func _process(delta: float) -> void:
	TimeText.text = "%sY-%sm-%sd -%sh" % [Global.YearCount, Global.MoonCount, Global.DayCount, Global.HourCount]
