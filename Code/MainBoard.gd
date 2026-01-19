extends Panel

@export var MaxGPU:int = 6
@onready var PickGpuCount: Label = $PickGPUCount
@onready var PowerButton: Button = $PowerButton
@onready var GPUListView: VBoxContainer = $MC/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer
var MonnETH:float = 0.0
var MonnPower:int = 0
var isOn:bool = false
var MaxPower:int = 0
var GpuList:Array[GpuCard]

func OverrideButtonFontColorTheme(btn:Button, c:Color):
	btn.add_theme_color_override("font_color", c)
	btn.add_theme_color_override("font_focus_color", c)
	btn.add_theme_color_override("font_hover_color", c)
	btn.add_theme_color_override("font_pressed_color", c)

func UpdataText():
	PickGpuCount.text = tr("已装载GPU: %s/%s") % [MaxGPU, GPUListView.get_child_count()]

func PickUpGPU(GPUC:GpuCard):
	if GPUListView.get_child_count() < MaxGPU:
		var gi:GPUItem = preload("uid://boxqa4tpeslwf").instantiate()
		GPUListView.add_child(gi)
		GPUC.OnBoard = true
		gi.Iint(GPUC, true)
		gi.remove_from_group("GPUItems")
		gi.add_to_group("GPUItemsOnBoard")
		Global.HasGpu.erase(GPUC)
		GpuList.append(GPUC)
		SignalNode.ReloadGpuList.emit()
		UpdataText()
	else:
		SignalNode.ShowCustomMessageBox.emit(tr("满了"), tr("显卡插槽已被使用殆尽"))

func _process(delta: float) -> void:
	UpdataText()
	if isOn:
		if GetAllGpuPower() > Global.MaxPower:
			ChangedMainBoardPower(false)

func GetAllGpuMh() -> float:
	var sum = 0
	for g:GPUItem in GPUListView.get_children():
		sum += g.Gpu.GetHashrate()
	return sum

func GeneralHandGpu():
	for i in GpuList:
		i.WorkHours += 1
		if i.RandomDamage and i.Broken == false:
			if i.WorkHours / 20 < randf():
				i.Broken = true
				i.Old = 0

func GetAllGpuPower() -> int:
	var sum = 0
	for g:GPUItem in GPUListView.get_children():
		sum += g.Gpu.GetPower()
		g.Gpu.OnBoard = true
	sum += 80
	return sum

func HourlySettlement():
	if isOn:
		MaxPower = 0
		GeneralHandGpu()
		var s = GetAllGpuMh()
		var day = s * Global.BaseHourETH
		var hour = day / 24
		Global.ETHMoney += day
		MonnETH += day
		SignalNode.UpdataMoney.emit()
		MaxPower = GetAllGpuPower()
		MonnPower += MaxPower
		Global.ElectricityPriceCount += ((GetAllGpuPower()+80) * 0.001) * Global.ElectricityPrice
		if Global.HasItems.has(Global.Items.GetPower):
			SignalNode.InfoMainBoard.emit(MaxGPU, GetAllGpuMh(), MaxPower)
		else:
			SignalNode.InfoMainBoard.emit(MaxGPU, GetAllGpuMh(), 80)

func DailyFinancialReport():
	if isOn:
		for g:GPUItem in GPUListView.get_children():
			g.Gpu.Aging()
			if g.Gpu.Edit:
				SignalNode.UpdataShowText.emit(g.Gpu)

func OneMoonPast():
	SignalNode.PastOneDayMoneyCount.emit(MonnETH, MonnPower)
	MonnETH = 0
	MonnPower = 0

func ClearAllGpus():
	Global.HasGpu.append_array(GpuList)
	GpuList = []
	for i in GPUListView.get_children():
		i.queue_free()

func LoadMainBoardGpusEvent(Gpus:Array[PackedScene], State:bool):
	ClearAllGpus()
	for i in Gpus:
		var g = i.instantiate()
		var gi:GPUItem = preload("uid://boxqa4tpeslwf").instantiate()
		GPUListView.add_child(gi)
		gi.Iint(g, true)
		GpuList.append(g)
		SignalNode.ReloadGpuList.emit()
		UpdataText()
	ChangedMainBoardPower(State)

func _ready() -> void:
	UpdataText()
	SignalNode.UpdataMainBoardText.connect(UpdataText)
	SignalNode.PickUPGPU.connect(PickUpGPU)
	SignalNode.ReloadGpuList.connect(UpdataText)
	SignalNode.PastOneHour.connect(HourlySettlement)
	SignalNode.PastOneDay.connect(DailyFinancialReport)
	SignalNode.PastOneMoon.connect(OneMoonPast)
	SignalNode.ClearMainBoardAllGpu.connect(ClearAllGpus)
	SignalNode.UpdateMainBoardMaxGpu.connect(func(maxGpu:int):MaxGPU=maxGpu)
	SignalNode.ChangedMainBoardPowerState.connect(func(power:bool): ChangedMainBoardPower(power))
	SignalNode.LoadMainBoardGpus.connect(LoadMainBoardGpusEvent)

func WhenPowerButtonClicked() -> void:
	isOn = not isOn
	ChangedMainBoardPower(isOn)

func ChangedMainBoardPower(PowerTip:bool):
	if PowerTip:
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
	isOn = PowerTip
