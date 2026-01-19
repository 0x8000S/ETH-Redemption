extends Control

@onready var MEC:Label = $MoneyErrorC/PC/MC/VC/Context
@onready var ME = $MoneyErrorC

@onready var CustomCenterView = $CustomMessageBox
@onready var CustomPanel = $CustomMessageBox/PanelContainer
@onready var CustomTitle = $CustomMessageBox/PanelContainer/MarginContainer/VBoxContainer/Title
@onready var CustomContext = $CustomMessageBox/PanelContainer/MarginContainer/VBoxContainer/Context

@onready var SellCenterView = $SellMessageBox
@onready var SellTitle = $SellMessageBox/PanelContainer/MarginContainer/VBoxContainer/Title
@onready var SellContext = $SellMessageBox/PanelContainer/MarginContainer/VBoxContainer/Context
@onready var Sell = $SellMessageBox/PanelContainer/MarginContainer/VBoxContainer/Sell
@onready var SellGiveUp = $SellMessageBox/PanelContainer/MarginContainer/VBoxContainer/GiveUp

@onready var DelWorldCenterView = $DelWorldMessageBox
@onready var DelWorldTitle = $DelWorldMessageBox/PanelContainer/MarginContainer/VBoxContainer/Title


var SellMoney:float = 0.0
var SellGpu:GpuCard = null

@onready var FixCenterView = $FixMessageBox
@onready var FixTitle = $FixMessageBox/PanelContainer/MarginContainer/VBoxContainer/Title
@onready var FixContext = $FixMessageBox/PanelContainer/MarginContainer/VBoxContainer/Context
@onready var FixLevel = $FixMessageBox/PanelContainer/MarginContainer/VBoxContainer/OptionButton
@onready var FixButton = $FixMessageBox/PanelContainer/MarginContainer/VBoxContainer/Fix
var FixGpu:GpuCard = null
var FixHp:float = 0.0
var FixOld:float = 0.0
var FixQuality:float = 0.0
var Pay:float = 0.0
var DelWorldName:String = ""

func EntranceAnimation(obj:CenterContainer):
	visible = true
	obj.visible = true
	var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await ani.tween_property(obj, "position:y", 0, 0.5).finished


func ExitAnimation(obj:CenterContainer):
	var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	await ani.tween_property(obj, "position:y", get_viewport_rect().size.y*-1, 0.5).finished
	obj.visible = false
	TurnOffVerification()


func ShowMoneyErrorMessageBoxEvent(Contexts:String):
	EntranceAnimation(ME)
	MEC.text = tr(MEC.text) % Contexts

func ShowCustomMessageBoxEvent(CustomTitles:String, CustomContexts:String, Level:String="N"):
	if Level == "E":
		CustomPanel.theme_type_variation = "ErrorPanel"
	EntranceAnimation(CustomCenterView)
	CustomTitle.text = CustomTitles
	CustomContext.text = CustomContexts

func ShowSellMessageBox(GPUC:GpuCard):
	EntranceAnimation(SellCenterView)
	SellGpu = GPUC
	SellMoney = 0.0
	SellTitle.text = tr("出售你的: %s显卡")
	SellContext.text = tr("购买价: ￥%s\n出售价: ￥%s")
	SellTitle.text = SellTitle.text % GPUC.Model
	SellMoney = float("%.2f" % (GPUC.MarketPrice * 0.7 - (1 - GPUC.Quality) * 10 - (1 - GPUC.Old) * 150 - (1 - GPUC.Health) * 20 + GPUC.GetHashrate()* 2))
	if GPUC.Broken:
		SellMoney *= 0.5
	SellContext.text = SellContext.text % [GPUC.MarketPrice, SellMoney]

func ShowFixMessageBox(GPUC:GpuCard):
	EntranceAnimation(FixCenterView)
	FixGpu = GPUC
	FixTitle.text = tr("修复你的%s显卡")
	FixContext.text = tr("寿命 %.2f->%.2f\n老化 %.2f->%.2f")
	FixButton.text = tr("修复(￥%s)")
	var fl = FixLevel.get_selected_id()
	Pay = 0
	for fi in range(FixLevel.item_count):
		FixLevel.set_item_disabled(fi, not Global.FixLevel[fi])
	FixTitle.text = FixTitle.text % FixGpu.Model
	FixHp = minf(FixGpu.Health+0.48*Global.FixLevelValue[fl]["H"], 1.0)
	Pay += Global.FixLevelValue[fl]["H"] * FixGpu.MarketPrice
	FixOld = minf(FixGpu.Old+0.4*Global.FixLevelValue[fl]["O"], 1.0)
	Pay += Global.FixLevelValue[fl]["O"] * FixGpu.MarketPrice
	if fl == 3:
		FixQuality = minf(FixGpu.Quality+FixGpu.Quality*Global.FixLevelValue[fl]["Q"], FixGpu.MaxQuality)
		Pay += Global.FixLevelValue[fl]["Q"] * 600
		FixContext.text += tr("\n品质提升 %.2f->%.2f")
		FixContext.text = FixContext.text % [FixGpu.Old, FixOld, FixGpu.Health,  FixHp, FixGpu.Quality, FixQuality]
	else:
		FixContext.text = FixContext.text % [FixGpu.Old, FixOld, FixGpu.Health,  FixHp]
	Pay = float("%.2f" % Pay)
	FixButton.text = FixButton.text % Pay
	if Global.Money < Pay:
		FixButton.disabled = true
	else:
		FixButton.disabled = false
	if FixGpu.Broken or FixGpu.Old == 0:
		FixButton.disabled = true
		FixContext.text = tr("显卡已完全损坏,无法修复!")

func ShowDelWorldMessageBoxEvent(WorldName:String):
	EntranceAnimation(DelWorldCenterView)
	DelWorldName = WorldName
	DelWorldTitle.text = tr("你真的要删除存档%s吗？") % WorldName

func _ready() -> void:
	SignalNode.ShowMoneyErrorMessageBox.connect(ShowMoneyErrorMessageBoxEvent)
	SignalNode.ShowCustomMessageBox.connect(ShowCustomMessageBoxEvent)
	SignalNode.ShowSellMessageBox.connect(ShowSellMessageBox)
	SignalNode.ShowFixMessageBox.connect(ShowFixMessageBox)
	SignalNode.ShowDelWorldMessageBox.connect(ShowDelWorldMessageBoxEvent)
	for i:CenterContainer in get_children():
		i.position.y = get_viewport_rect().size.y * -1

func TurnOffVerification():
	for i:CenterContainer in get_children():
		if i.visible == true:
			return
	await get_tree().create_timer(0.6).timeout
	visible = false

func WhenMEOKButtonClicked() -> void:
	MEC.text = tr("你没有足够的钱去购买%s")
	ExitAnimation(ME)


func WhenCustomMessageBoxOKButtonClicked() -> void:
	CustomPanel.theme_type_variation = ""
	CustomTitle.text = ""
	CustomContext.text = ""
	ExitAnimation(CustomCenterView)

func WhenSellGiveUpButtonClicked() -> void:
	SellGpu = null
	ExitAnimation(SellCenterView)


func WhenSellButtonClicked() -> void:
	SignalNode.UnEditGPU.emit(SellGpu)
	Global.HasGpu.erase(SellGpu)
	SellGpu = null;
	Global.Money += SellMoney
	SellMoney = 0
	SignalNode.ReloadGpuList.emit()
	ExitAnimation(SellCenterView)


func WhenOptionButtonChanged(index: int) -> void:
	if FixGpu:
		FixTitle.text = tr("修复你的%s显卡")
		FixContext.text = tr("寿命 %.2f->%.2f\n老化 %.2f->%.2f")
		FixButton.text = tr("修复(￥%s)")
		var fl = index
		Pay = 0
		for fi in range(FixLevel.item_count):
			FixLevel.set_item_disabled(fi, not Global.FixLevel[fi])
		FixTitle.text = FixTitle.text % FixGpu.Model
		FixHp = minf(FixGpu.Health+0.48*Global.FixLevelValue[fl]["H"], 1.0)
		Pay += Global.FixLevelValue[fl]["H"] * FixGpu.MarketPrice
		FixOld = minf(FixGpu.Old+0.4*Global.FixLevelValue[fl]["O"], 1.0)
		Pay += Global.FixLevelValue[fl]["O"] * FixGpu.MarketPrice
		Pay += Global.FixLevelValue[fl]["O"] * FixGpu.MarketPrice
		if fl == 3:
			FixQuality = minf(FixGpu.Quality+FixGpu.Quality*Global.FixLevelValue[fl]["Q"], FixGpu.MaxQuality)
			Pay += Global.FixLevelValue[fl]["Q"] * 600
			FixContext.text += tr("\n品质提升 %.2f->%.2f")
			FixContext.text = FixContext.text % [FixGpu.Old, FixOld, FixGpu.Health,  FixHp, FixGpu.Quality, FixQuality]
		else:
			FixQuality = 0.0
			FixContext.text = FixContext.text % [FixGpu.Old, FixOld, FixGpu.Health,  FixHp]
		Pay = float("%.2f" % Pay)
		FixButton.text = FixButton.text % Pay
		if Global.Money < Pay:
			FixButton.disabled = true
		else:
			FixButton.disabled = false
		if FixGpu.Broken or FixGpu.Old == 0:
			FixButton.disabled = true
			FixContext.text = tr("显卡已完全损坏,无法修复!")


func WhenFixButtonClicked() -> void:
	SignalNode.UpdataShowText.emit(FixGpu)
	FixGpu.Health = FixHp
	FixGpu.Old = FixOld
	if FixQuality != 0:
		FixGpu.Quality = FixQuality
	Global.Money -= Pay
	ExitAnimation(FixCenterView)


func WhenFixCancelClicked() -> void:
	ExitAnimation(FixCenterView)


func WhenDelWorldOKButtonClicked() -> void:
	if FileAccess.file_exists("user://%s.tres" % DelWorldName):
		DirAccess.remove_absolute("user://%s.tres" % DelWorldName)
		SignalNode.DelWorld.emit()
	WhenDelWorldCancelButtonClicked()


func WhenDelWorldCancelButtonClicked() -> void:
	DelWorldName = ""
	ExitAnimation(DelWorldCenterView)
