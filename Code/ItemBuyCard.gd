extends PanelContainer

class_name ItemBuyCard

signal ReloadItemsView

@export var ItemName:Label
@export var ItemPrice:Label
@export var BuyButton:BaseButton
var Itemc:Global.Items

func Init(item:Global.Items):
	Itemc = item
	ItemName.text = Global.ItemsText[item]
	if Global.HasItems.has(item):
		BuyButton.disabled = true
		ItemName.text += "(已购买)"
	ItemPrice.text = "￥%s" % Global.ItemsPrice[item]

func WhenBuyButtonClicked() -> void:
	if Global.Money < Global.ItemsPrice[Itemc]:
		SignalNode.ShowMoneyErrorMessageBox.emit("道具%s" % Global.ItemsText[Itemc])
	else:
		Global.Money -= Global.ItemsPrice[Itemc]
		Global.HasItems.append(Itemc)
		ReloadItemsView.emit()
	
