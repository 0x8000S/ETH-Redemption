extends Node

func SwitchVenueSignal(venue:Global.Venue):
    Global.NowSetVenue = venue
    SignalNode.ClearMainBoardAllGpu.emit()
    SignalNode.ChangedMainBoardPowerState.emit(false)
    SignalNode.UpdateMainBoardMaxGpu.emit(Global.VenueInfo[venue][1])
    Global.ElectricityPrice = Global.VenueInfo[venue][2]
    Global.MaxPower = Global.VenueInfo[venue][3]

func _ready() -> void:
    SignalNode.SwitchVenue.connect(SwitchVenueSignal)