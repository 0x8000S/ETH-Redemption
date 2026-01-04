extends PanelContainer

class_name ItemBuyCard

signal ReloadItemsView
signal ReloadVenueView

@export var ItemName:Label
@export var ItemPrice:Label
@export var BuyButton:BaseButton
var Itemc:Global.Items
var Itemv:Global.Venue
var InitMode = "I"

func Init(item:Global.Items):
	InitMode = "I"
	Itemc = item
	ItemName.text = Global.ItemsText[item]
	if Global.HasItems.has(item):
		BuyButton.disabled = true
		ItemName.text += "(已购买)"
	ItemPrice.text = "￥%s" % Global.ItemsPrice[item]

func InitH(venues:Global.Venue):
	InitMode = "V"
	Itemv = venues
	ItemName.text = Global.VenueInfo[Itemv][0]
	if Global.HasVenue.has(venues):
		BuyButton.text = "搬入"
		ItemName.text += "(已购买)"
		if Global.NowSetVenue == venues:
			BuyButton.disabled = true
	ItemPrice.text = "￥%s" % Global.VenueInfo[venues][4]

func WhenBuyButtonClicked() -> void:
	if InitMode == "I":
		if Global.Money < Global.ItemsPrice[Itemc]:
			SignalNode.ShowMoneyErrorMessageBox.emit("道具%s" % Global.ItemsText[Itemc])
		else:
			Global.Money -= Global.ItemsPrice[Itemc]
			Global.HasItems.append(Itemc)
			ReloadItemsView.emit()
			match Itemc:
				Global.Items.FixLevel1:
					Global.FixLevel[1] = 1
				Global.Items.FixLevel2:
					Global.FixLevel[2] = 1
				Global.Items.FixLevel3:
					Global.FixLevel[3] = 1
	if InitMode == "V":
		if Global.HasVenue.has(Itemv):
			SignalNode.SwitchVenue.emit(Itemv)
			ReloadVenueView.emit()
			SignalNode.ReloadGpuList.emit()
		else:
			if Global.Money < Global.VenueInfo[Itemv][4]:
				SignalNode.ShowMoneyErrorMessageBox.emit("场地%s" % Global.VenueInfo[Itemv][0])
			else:
				Global.Money -= Global.VenueInfo[Itemv][4]
				Global.HasVenue.append(Itemv)
				ReloadVenueView.emit()