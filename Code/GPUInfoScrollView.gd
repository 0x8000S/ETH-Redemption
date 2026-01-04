extends ScrollContainer

@onready var GpuName: Label = $VBoxContainer/GPUName
@onready var Hashrate: Label = $VBoxContainer/Hashrate
@onready var Power: Label = $VBoxContainer/Power
@onready var Health: Label = $VBoxContainer/Health
@onready var Old: Label = $VBoxContainer/Old
@onready var Quality: Label = $VBoxContainer/Quality
var NowEditGpu:GpuCard

func UpdataData(GPUC:GpuCard):
	GpuName.text = GPUC.Model
	Hashrate.text = "算力: %.2fMH/S" % GPUC.GetHashrate()
	Power.text = "功耗: %sW" % GPUC.GetPower()
	Health.text = "健康度: %.3f" % GPUC.Old
	Old.text = "老化系数: %.3f" % GPUC.Health
	Quality.text = "体质: %s" % int(GPUC.Quality * 100)


func EditGPU(GPUC:GpuCard):
	NowEditGpu = GPUC
	UpdataData(GPUC)

func Updata():
	if NowEditGpu:
		UpdataData(NowEditGpu)

func _ready() -> void:
	SignalNode.PastOneHour.connect(Updata)
	SignalNode.EditGPU.connect(EditGPU)
	SignalNode.UpdataShowText.connect(EditGPU)
	SignalNode.UnEditGPU.connect(Rest)

func _process(delta: float) -> void:
	Updata()


func Rest(GPUC:GpuCard):
	NowEditGpu = null
	GpuName.text = "GPUNAME"
	Hashrate.text = "算力: --MH/S"
	Power.text = "功耗: --W"
	Health.text = "健康度: --"
	Old.text = "老化系数: --"
	Quality.text = "体质: --"
