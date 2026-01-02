extends ScrollContainer

@onready var Have = $VBoxContainer/Have
@onready var Tr = $VBoxContainer/Tr
@onready var Ebt = $VBoxContainer/ElectricityBillText
@onready var Cm = $VBoxContainer/CurrentMoney
@onready var Cbt = $VBoxContainer/CurrentElectricityBill
var NowETH:float = 0
func UpdataETHMoney(p:float):
	Tr.text = "1ETH = %.2f￥" % (p * 6.14)
	NowETH = p * 6.14

func Updata():
	Ebt.text = "累计电费: ￥%.2f" % Global.ElectricityPriceCount
	Cm.text = "当前持有资金: \n￥%.2f" % Global.Money
	Have.text = str("当前拥有: %.5f ETH" % Global.ETHMoney)
	Cbt.text = "当前电价: ￥%.2f" % Global.ElectricityPrice

func _ready() -> void:
	Cbt.text = "当前电价: ￥%.2f" % Global.ElectricityPrice
	SignalNode.PriceChanged.connect(UpdataETHMoney)

func _process(delta: float) -> void:
	Updata()


func WhenClacButtonClicked() -> void:
	Global.Money += float("%.2f" % (Global.ETHMoney * NowETH))
	Global.ETHMoney = 0
