extends Control

@onready var MaxGpuText:Label = $VBoxContainer/MaxGPU
@onready var SumHmsText:Label = $VBoxContainer/SumMHS
@onready var SumPowerText:Label = $VBoxContainer/SumPower

func UpdataText(MaxGpus:int, SumMHS:float, MaxPower:int):
    MaxGpuText.text = tr("最大支持显卡数: %s") % MaxGpus
    SumHmsText.text = tr("主板显卡总算力:\n %.2fMH/s") % SumMHS
    SumPowerText.text = tr("总功耗: %sW") % MaxPower

func _ready() -> void:
    SignalNode.InfoMainBoard.connect(UpdataText)