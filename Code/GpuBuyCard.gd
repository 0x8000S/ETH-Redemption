extends PanelContainer

class_name GpuBuyCard

signal Buy(GPUC, SELF)

@export var Gpu:GpuCard
func Init(gpu:Global.Gpu):
	var g = GpuGroup.GpuBox[gpu].instantiate()
	Gpu = g
	Gpu.Quality = randf_range(Gpu.MinQuality, Gpu.MaxQuality)
	Gpu.MarketPrice += Gpu.Quality * 100 + randi_range(-95, 80)
	$MarginContainer/VBoxContainer/GpuName.text = g.Model
	$MarginContainer/VBoxContainer/SubTitle.text = "基础算力: %sMH/S\nTDP: %sW\n显存: %sG\n定价: ￥%s" % [Gpu.BaseHashrate, Gpu.DefaultPower, Gpu.Vram, Gpu.MarketPrice]



func WhenBuyButtonClick() -> void:
	Buy.emit(Gpu, self)
