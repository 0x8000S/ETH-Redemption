extends Control

@onready var MEC:Label = $MoneyErrorC/PC/MC/VC/Context
@onready var ME = $MoneyErrorC

@onready var CustomCenterView = $CustomMessageBox
@onready var CustomTitle = $CustomMessageBox/PanelContainer/MarginContainer/VBoxContainer/Title
@onready var CustomContext = $CustomMessageBox/PanelContainer/MarginContainer/VBoxContainer/Context

@onready var SellCenterView = $SellMessageBox
@onready var SellTitle = $SellMessageBox/PanelContainer/MarginContainer/VBoxContainer/Title
@onready var SellContext = $SellMessageBox/PanelContainer/MarginContainer/VBoxContainer/Context
@onready var Sell = $SellMessageBox/PanelContainer/MarginContainer/VBoxContainer/Sell
@onready var SellGiveUp = $SellMessageBox/PanelContainer/MarginContainer/VBoxContainer/GiveUp
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

func ShowMoneyErrorMessageBoxEvent(Contexts:String):
    ME.visible = true
    visible = true
    MEC.text = MEC.text % Contexts

func ShowCustomMessageBoxEvent(CustomTitles:String, CustomContexts:String):
    visible = true
    CustomCenterView.visible = true
    CustomTitle.text = CustomTitles
    CustomContext.text = CustomContexts

func ShowSellMessageBox(GPUC:GpuCard):
    visible = true
    SellGpu = GPUC
    SellCenterView.visible = true
    SellMoney = 0.0
    SellTitle.text = "出售你的: %s显卡"
    SellContext.text = "购买价: ￥%s\n出售价: ￥%s"
    SellTitle.text = SellTitle.text % GPUC.Model
    SellMoney = float("%.2f" % (GPUC.MarketPrice * 0.7 - (1 - GPUC.Quality) * 10 - (1 - GPUC.Old) * 150 - (1 - GPUC.Health) * 20 + GPUC.GetHashrate()* 2))
    SellContext.text = SellContext.text % [GPUC.MarketPrice, SellMoney]

func ShowFixMessageBox(GPUC:GpuCard):
    FixGpu = GPUC
    visible = true
    FixCenterView.visible = true
    FixTitle.text = "修复你的%s显卡"
    FixContext.text = "寿命 %.2f->%.2f\n老化 %.2f->%.2f"
    FixButton.text = "修复(￥%s)"
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
        FixContext.text += "\n品质提升 %s->%s"
        FixContext.text = FixContext.text % [FixGpu.Old, FixOld, FixGpu.Health,  FixHp, FixGpu.Quality, FixQuality]
    else:
        FixContext.text = FixContext.text % [FixGpu.Old, FixOld, FixGpu.Health,  FixHp]
    Pay = float("%.2f" % Pay)
    FixButton.text = FixButton.text % Pay
    if Global.Money < Pay:
        FixButton.disabled = true
    else:
        FixButton.disabled = false

func _ready() -> void:
    SignalNode.ShowMoneyErrorMessageBox.connect(ShowMoneyErrorMessageBoxEvent)
    SignalNode.ShowCustomMessageBox.connect(ShowCustomMessageBoxEvent)
    SignalNode.ShowSellMessageBox.connect(ShowSellMessageBox)
    SignalNode.ShowFixMessageBox.connect(ShowFixMessageBox)

func WhenMEOKButtonClicked() -> void:
    ME.visible = false
    MEC.text = "你没有足够的钱去购买%s"
    visible = false


func WhenCustomMessageBoxOKButtonClicked() -> void:
    visible = false
    CustomCenterView.visible = false
    CustomTitle.text = ""
    CustomContext.text = ""

func WhenSellGiveUpButtonClicked() -> void:
    SellGpu = null
    SellCenterView.visible = false
    visible = false


func WhenSellButtonClicked() -> void:
    SignalNode.UnEditGPU.emit(SellGpu)
    Global.HasGpu.erase(SellGpu)
    SellGpu = null;
    Global.Money += SellMoney
    SellMoney = 0
    SellCenterView.visible = false
    visible = false
    SignalNode.ReloadGpuList.emit()


func WhenOptionButtonChanged(index: int) -> void:
    if FixGpu:
        FixTitle.text = "修复你的%s显卡"
        FixContext.text = "寿命 %.2f->%.2f\n老化 %.2f->%.2f"
        FixButton.text = "修复(￥%s)"
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
            FixContext.text += "\n品质提升 %s->%s"
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


func WhenFixButtonClicked() -> void:
    SignalNode.UpdataShowText.emit(FixGpu)
    FixGpu.Health = FixHp
    FixGpu.Old = FixOld
    if FixQuality != 0:
        FixGpu.Quality = FixQuality
    Global.Money -= Pay
    
    FixCenterView.visible = false
    visible = false


func WhenFixCancelClicked() -> void:
    FixCenterView.visible = false
    visible = false
