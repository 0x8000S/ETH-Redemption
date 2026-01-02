extends Panel

@export var MaxGPU:int = 6
@onready var PickGpuCount: Label = $PickGPUCount
@onready var PowerButton: Button = $PowerButton
@onready var GPUList: VBoxContainer = $MC/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer
var MonnETH:float = 0.0
var MonnPower:int = 0
var isOn:bool = false
var MaxPower:int = 0

func OverrideButtonFontColorTheme(btn:Button, c:Color):
	btn.add_theme_color_override("font_color", c)
	btn.add_theme_color_override("font_focus_color", c)
	btn.add_theme_color_override("font_hover_color", c)
	btn.add_theme_color_override("font_pressed_color", c)

func UpdataText():
	PickGpuCount.text = "已装载GPU: %s/%s" % [MaxGPU, GPUList.get_child_count()]

func PickUpGPU(GPUC:GpuCard):
	if GPUList.get_child_count() < MaxGPU:
		var gi:GPUItem = preload("uid://boxqa4tpeslwf").instantiate()
		GPUList.add_child(gi)
		GPUC.OnBoard = true
		gi.Iint(GPUC, true)
		Global.HasGpu.erase(GPUC)
		SignalNode.ReloadGpuList.emit()
		UpdataText()
	else:
		SignalNode.ShowCustomMessageBox.emit("满了", "显卡插槽已被使用殆尽")

func _process(delta: float) -> void:
	UpdataText()

func GetAllGpuMh() -> float:
	var sum = 0
	for g:GPUItem in GPUList.get_children():
		sum += g.Gpu.GetHashrate()
	return sum

func GetAllGpuPower() -> int:
	var sum = 0
	for g:GPUItem in GPUList.get_children():
		sum += g.Gpu.GetPower()
	sum += 80
	return sum

func HourlySettlement():
	if isOn:
		MaxPower = 0
		var s = GetAllGpuMh()
		var day = s * Global.BaseHourETH
		var hour = day / 24
		Global.ETHMoney += day
		MonnETH += day
		SignalNode.UpdataMoney.emit()
		MaxPower = GetAllGpuPower()
		MonnPower += MaxPower
		Global.ElectricityPriceCount += ((GetAllGpuPower()+80) * 0.001) * Global.ElectricityPrice
		SignalNode.InfoMainBoard.emit(MaxGPU, GetAllGpuMh(), MaxPower)

func DailyFinancialReport():
	if isOn:
		for g:GPUItem in GPUList.get_children():
			g.Gpu.Aging()
			if g.Gpu.Edit:
				SignalNode.UpdataShowText.emit(g.Gpu)

func OneMoonPast():
	SignalNode.PastOneDayMoneyCount.emit(MonnETH, MonnPower)
	MonnETH = 0
	MonnPower = 0

func _ready() -> void:
	UpdataText()
	SignalNode.UpdataMainBoardText.connect(UpdataText)
	SignalNode.PickUPGPU.connect(PickUpGPU)
	SignalNode.ReloadGpuList.connect(UpdataText)
	SignalNode.PastOneHour.connect(HourlySettlement)
	SignalNode.PastOneDay.connect(DailyFinancialReport)
	SignalNode.PastOneMoon.connect(OneMoonPast)

func WhenPowerButtonClicked() -> void:
	isOn = not isOn
	if isOn:
		SignalNode.InfoMainBoard.emit(MaxGPU, GetAllGpuMh(), GetAllGpuPower())
		PowerButton.text = "Power: ON"
		OverrideButtonFontColorTheme(PowerButton, Color(1,0.2,0.2))
		Global.MainBoardPowerState = true
		SignalNode.PowerUpMainBoard.emit()
	else:
		SignalNode.InfoMainBoard.emit(MaxGPU, 0, 0)
		PowerButton.text = "Power: OFF"
		OverrideButtonFontColorTheme(PowerButton, Color.WHITE)
		Global.MainBoardPowerState = false
		SignalNode.PowerDownMainBoard.emit()
