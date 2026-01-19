extends Node

class_name SaveLoadNode

var SavePath:String = "user://"
var LoadPath:String = "user://"

func ListSaveFiles() -> Array[String]:
	var ReturnValue:Array[String] = []
	var FilePath = DirAccess.open(LoadPath)
	FilePath.list_dir_begin()
	var FileName = FilePath.get_next()
	while FileName != "":
		print(FileName)
		if not FilePath.current_is_dir():
			if FileName.get_basename() != "LanguageSetting":
				ReturnValue.append(FileName.get_basename())
		FileName = FilePath.get_next()
	FilePath.list_dir_end()
	return ReturnValue

func SaveToFile(WriteFile:String) -> void:
	print("user://%s.tres" % WriteFile)
	var data = SaveGameData.new()
	data.Money = Global.Money
	data.ETHMoney = Global.ETHMoney
	data.ElectricityPrice = Global.ElectricityPrice
	data.ElectricityPriceCount = Global.ElectricityPriceCount
	data.DayCount = Global.DayCount
	data.HourCount = Global.HourCount
	data.MoonCount = Global.MoonCount
	data.YearCount = Global.YearCount
	data.BaseETH = Global.BaseETH
	data.BaseHourETH = Global.BaseHourETH
	data.MainBoardPowerState = Global.MainBoardPowerState
	data.HourTime = Global.HourTime
	data.ZoomValue = Global.ZoomValue
	data.MaxPower = Global.MaxPower
	data.NowSetVenue = Global.NowSetVenue
	data.HasVenue = Global.HasVenue
	data.HasItems = Global.HasItems
	data.FixLevel = Global.FixLevel
	var GIS = get_tree().get_nodes_in_group("GPUList")
	var GIOBS = get_tree().get_nodes_in_group("GPUListOnBoard")
	print("Number of GPU UI nodes:", GIS.size())
	for i in Global.HasGpu:
		print("SI")
		var packs = PackedScene.new()
		packs.pack(i)
		data.GPUItems.append(packs)
	for i in GIOBS:
		print("So")
		var packs = PackedScene.new()
		packs.pack(i.Gpu)
		data.GPUItemsOnBoard.append(packs)
	ResourceSaver.save(data, "user://%s.tres" % WriteFile)
	SignalNode.LoadSaveFile.emit()

func LoadToFile(LoadFile:String):
	ListSaveFiles()
	var data = ResourceLoader.load("user://%s.tres" % LoadFile) as SaveGameData
	print("Load")
	print(data.NowSetVenue)
	Global.Rest()
	Global.LoadedWorld = LoadFile
	SignalNode.LoadSaveFile.emit()
	Global.Money = data.Money
	Global.ETHMoney = data.ETHMoney
	Global.ElectricityPrice = data.ElectricityPrice
	Global.ElectricityPriceCount = data.ElectricityPriceCount
	Global.DayCount = data.DayCount
	Global.HourCount = data.HourCount
	Global.MoonCount = data.MoonCount
	Global.YearCount = data.YearCount
	Global.BaseETH = data.BaseETH
	Global.BaseHourETH = data.BaseHourETH
	Global.MainBoardPowerState = data.MainBoardPowerState
	Global.HourTime = data.HourTime
	Global.ZoomValue = data.ZoomValue
	Global.MaxPower = data.MaxPower
	Global.NowSetVenue = data.NowSetVenue
	Global.HasVenue = data.HasVenue
	Global.HasItems = data.HasItems
	Global.FixLevel = data.FixLevel
	SignalNode.SwitchVenue.emit(Global.NowSetVenue)
	SignalNode.SyncTimeZoomValue.emit()
	SignalNode.LoadGpuList.emit(data.GPUItems)
	SignalNode.LoadMainBoardGpus.emit(data.GPUItemsOnBoard, data.MainBoardPowerState)
