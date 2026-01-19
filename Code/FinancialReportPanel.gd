extends PanelContainer

@onready var Eth: Label = $MarginContainer/VBoxContainer/ETH
@onready var Power: Label = $MarginContainer/VBoxContainer/Power
@onready var PowerPrice: Label = $MarginContainer/VBoxContainer/PowerPrice

func Count(ETH:float, PowerT:float):
	Eth.text = tr("当月挖去ETH: %s") % ETH
	Power.text = tr("消耗电源 %sW") % PowerT
	PowerPrice.text = tr("电费: ￥%s") % ((PowerT * 0.001)*Global.ElectricityPrice)
	Global.Money -= ((PowerT * 0.001)*Global.ElectricityPrice)
	Global.ElectricityPriceCount = 0
	get_parent().visible = true

func _ready() -> void:
	SignalNode.PastOneDayMoneyCount.connect(Count)

func WhenCloseButtonClicked() -> void:
	get_parent().visible = false
