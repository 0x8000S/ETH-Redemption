extends PanelContainer


class_name GPUCheck
@onready var GpuName = $MarginContainer/VBoxContainer/Label
var vEGPU:Global.Gpu

func Init(EGPU:Global.Gpu):
	vEGPU = EGPU
	var g:GpuCard = GpuGroup.GpuBox[EGPU].instantiate()
	GpuName.text = g.Model
	g.queue_free()

func WhenCheckButtonClicked() -> void:
	SignalNode.CheckGpu.emit(vEGPU)