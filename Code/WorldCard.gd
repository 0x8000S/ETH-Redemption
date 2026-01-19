extends PanelContainer

class_name WorldCard
var WorldName
var info:SaveGameData
@onready var WorldNameLabel = $MarginContainer/VBoxContainer/WorldName
@onready var WorldInfoLabel = $MarginContainer/VBoxContainer/WorldInfo

func Init(WorldNames:String):
	print("user://%s.tres" % WorldName)
	WorldName = WorldNames
	WorldNameLabel.text = WorldName
	if FileAccess.file_exists("user://%s.tres" % WorldName):
		info = ResourceLoader.load("user://%s.tres" % WorldName) as SaveGameData
		WorldInfoLabel.text = tr("已过去%s年%s月%s天%s时 | ￥%s") % [info.YearCount, info.MoonCount, info.DayCount, info.HourCount, info.Money]


func WhenDelButtonClicked() -> void:
	SignalNode.ShowDelWorldMessageBox.emit(WorldName)


func WhenLoadButtonClicked() -> void:
	Global.LoadedWorld = WorldName
	SignalNode.LoadWorld.emit(WorldName)
