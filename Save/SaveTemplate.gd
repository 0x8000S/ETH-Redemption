extends Resource

class_name SaveGameData

@export_storage var GPUItems: Array[PackedScene]
@export_storage var GPUItemsOnBoard: Array[PackedScene]
@export_storage var GPUBuyCards: Array[PackedScene]

@export_storage var Money:float
@export_storage var ETHMoney:float
@export_storage var ElectricityPrice:float
@export_storage var ElectricityPriceCount:float
@export_storage var DayCount:int
@export_storage var HourCount:int
@export_storage var MoonCount:int
@export_storage var YearCount:int
@export_storage var BaseETH:float
@export_storage var BaseHourETH:float
@export_storage var MainBoardPowerState:bool
@export_storage var HourTime
@export_storage var ZoomValue
@export_storage var MaxPower
@export_storage var HasVenue:Array[Global.Venue]
@export_storage var NowSetVenue:Global.Venue
@export_storage var HasItems:Array[Global.Items]
@export_storage var FixLevel:Array[bool]
@export_storage var HasGpu:Array[PackedScene]