extends Control

@onready var label: Label = $Label
@onready var label_2: Label = $Label2

func UpdataDate():
	label.text = str(Global.DayCount)
	label_2.text = str(Global.HourCount)

func UB(p:float):
	$Label3.text = str(p * 6.13)

func _ready() -> void:
	SignalNode.PastOneHour.connect(UpdataDate)
	SignalNode.PriceChanged.connect(UB)
