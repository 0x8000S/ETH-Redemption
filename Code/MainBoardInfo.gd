extends Control

@onready var MaxGpuText:Label = $VBoxContainer/MaxGPU
@onready var SumHmsText:Label = $VBoxContainer/SumMHS
@onready var SumPowerText:Label = $VBoxContainer/SumPower

func UpdataText(MaxGpus:int, SumMHS:float, MaxPower:int):
    MaxGpuText.text = "最大支持显卡数: %s" % MaxGpus
    SumHmsText.text = "主板显卡总算力:\n %.2fMH/S" % SumMHS
    SumPowerText.text = "总功耗: %sW" % MaxPower

func _ready() -> void:
    SignalNode.InfoMainBoard.connect(UpdataText)