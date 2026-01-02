extends Node

@onready var HoursTimer = $HOUR

func _ready() -> void:
    HoursTimer.wait_time = Global.GetHourTime()
    HoursTimer.start()

func WhenOneHourPast() -> void:
    if Global.HourCount + 1 == 24:
        Global.HourCount = 0
        Global.DayCount += 1
        if Global.DayCount == 31:
            Global.DayCount = 0
            Global.MoonCount += 1
            SignalNode.PastOneMoon.emit()
        if Global.MoonCount == 13:
            Global.MoonCount = 0
            Global.YearCount += 1
            SignalNode.PastOneYear.emit()
        SignalNode.PastOneDay.emit()
        SignalNode.PastOneHour.emit()
        HoursTimer.wait_time = Global.GetHourTime()
        HoursTimer.start()
        return
    Global.HourCount += 1
    SignalNode.PastOneHour.emit()
    HoursTimer.wait_time = Global.GetHourTime()
    HoursTimer.start()
