extends PanelContainer

class_name GPUItem

@onready var GpuName:Label = $MarginContainer/VBoxContainer/GPUNAME
@onready var PickUp:Button = $MarginContainer/VBoxContainer/HBoxContainer/PickUP
@onready var Edit:Button = $MarginContainer/VBoxContainer/HBoxContainer/Edit
@onready var Sell:Button = $MarginContainer/VBoxContainer/HBoxContainer/Sell
@onready var ChangedBIOS = $MarginContainer/VBoxContainer/ChangeBIOS
@onready var Fix = $MarginContainer/VBoxContainer/HBoxContainer/Fix
var Gpu:GpuCard
@onready var NormalView = $MarginContainer/VBoxContainer/HBoxContainer
@onready var LHRView = $MarginContainer/VBoxContainer/ChangeBIOSHC
@onready var LHRUnlock = $MarginContainer/VBoxContainer/ChangeBIOSHC/Buy
var UnEditSignalSend:bool = false
var onBoard:bool = false


func EditGpuEvent(GPUC:GpuCard):
	if UnEditSignalSend == false:
		$Editing.visible = false
		Edit.text = "编辑"
		Gpu.Edit = false
	UnEditSignalSend = false

func PastOneHourEvent():
	if Gpu.Old == 0:
		$Error.visible = true
	else:
		$Error.visible = false

func Iint(GPUC:GpuCard, onBoardf=false):
	onBoard = onBoardf
	Gpu = GPUC
	GpuName.text = Gpu.Model
	GpuName.tooltip_text = Gpu.Model
	SignalNode.EditGPU.connect(EditGpuEvent)
	SignalNode.PastOneHour.connect(PastOneHourEvent)
	SignalNode.PowerUpMainBoard.connect(func():PickUp.disabled = true)
	SignalNode.PowerDownMainBoard.connect(func():PickUp.disabled = false)
	
	if Global.MainBoardPowerState:
		PickUp.disabled = true
	if Gpu.Edit:
		$Editing.visible = true
		Edit.text = "取消编辑"
	if onBoard:
		PickUp.text = "卸下"
		Fix.visible = false
		Sell.visible = false
	else:
		if Gpu.LHR:
			ChangedBIOS.visible = true


func WhenEditButtonClicked() -> void:
	if Gpu.Edit == false:
		Gpu.Edit = true
		UnEditSignalSend = true
		SignalNode.EditGPU.emit(Gpu)
		$Editing.visible = true
		Edit.text = "取消编辑"
		if not onBoard:
			SignalNode.OCGPU.emit(Gpu, self)
	else:
		Gpu.Edit = false
		SignalNode.UnEditGPU.emit(Gpu)
		$Editing.visible = false
		Edit.text = "编辑"

func WhenPickUpButtonClicked() -> void:
	if onBoard:
		Global.HasGpu.append(Gpu)
		queue_free()
		Gpu.OnBoard = false
		SignalNode.ReloadGpuList.emit()
		SignalNode.UpdataMainBoardText.emit()
		SignalNode.OCGPU.emit(Gpu, self)
	else:
		Gpu.OnBoard = true
		SignalNode.PickUPGPU.emit(Gpu)


func WhenChangedBIOSButtonClicked() -> void:
	NormalView.visible = false
	ChangedBIOS.visible = false
	LHRView.visible = true
	if Global.Money < 200:
		LHRUnlock.disabled = true
	else:
		LHRUnlock.disabled = false
	

func WhenLHRCancelButtonClicked() -> void:
	NormalView.visible = true
	ChangedBIOS.visible = true
	LHRView.visible = false


func WhenBuyBIOSButtonClicked() -> void:
	Global.Money -= 200
	Gpu.LHR = false
	WhenLHRCancelButtonClicked()
	ChangedBIOS.visible = false


func WhenSellButtonClicked() -> void:
	SignalNode.ShowSellMessageBox.emit(Gpu)


func WhenFixButtonClicked() -> void:
	SignalNode.ShowFixMessageBox.emit(Gpu)
