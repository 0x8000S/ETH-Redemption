extends Panel


@onready var OcText: Label = $MC/VBoxContainer/Core/Label
@onready var VramText: Label = $MC/VBoxContainer/VRam/Label
@onready var OffsetVoltText: Label = $MC/VBoxContainer/OffsetVolt/Label
@onready var Oc: HSlider = $MC/VBoxContainer/Core/HSlider
@onready var Vram: HSlider = $MC/VBoxContainer/VRam/HSlider
@onready var OffsetVolt: HSlider = $MC/VBoxContainer/OffsetVolt/HSlider


var OCGpu:GpuCard
func OCGpuC(GPUC:GpuCard, GPUI:GPUItem):
	EditOcGroup(true)
	OCGpu = GPUC
	OcText.text = tr("核心+%sMhz") % int(GPUC.OCCore)
	VramText.text = tr("显存+%sMHz") % int(GPUC.OCMem)
	OffsetVoltText.text = tr("电压-%smv") % GPUC.OffsetVolt
	Oc.value = int(GPUC.OCCore)
	Vram.value = int(GPUC.OCMem)
	OffsetVolt.value = GPUC.OffsetVolt

func EditOcGroup(state:bool) -> void:
	Oc.editable = state
	Vram.editable = state
	OffsetVolt.editable = state

func UnEditOc(GPUC:GpuCard):
	OCGpu = null
	EditOcGroup(false)

func PickUpGpuFunc(GPUC:GpuCard):
	if GPUC == OCGpu:
		OCGpu = null
		EditOcGroup(false)

func _ready() -> void:
	SignalNode.OCGPU.connect(OCGpuC)
	SignalNode.UnEditGPU.connect(UnEditOc)
	SignalNode.PickUPGPU.connect(PickUpGpuFunc)
	SignalNode.LoadSaveFile.connect(LoadSaveFileEvent)
	EditOcGroup(false)

func LoadSaveFileEvent():
	EditOcGroup(false)
	Oc.value = 0
	Vram.value = 0
	OffsetVolt.value = 0
	OCGpu = null

func WhenApplyButtonClicked() -> void:
	if OCGpu:
		OCGpu.OCCore = Oc.value
		OCGpu.OCMem = Vram.value
		OCGpu.OffsetVolt = OffsetVolt.value
		OCGpu.CalcOcLimit()
		SignalNode.UpdataShowText.emit(OCGpu)


func WhenCSliderChanged(value: float) -> void:
	OcText.text = tr("核心+%sMhz") % value



func WhenVramSliderChanged(value: float) -> void:
	VramText.text = tr("显存+%sMHz") % value



func WhenOVSliderChanged(value: float) -> void:
	OffsetVoltText.text = tr("电压-%smv") % value
