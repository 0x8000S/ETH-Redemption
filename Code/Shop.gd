extends Control

@onready var GPUFlow = $Margin/MainPanel/Margin/VBox/Tabs/显卡/Marign/Scroll/GPU_Flow
@onready var Money:Label = $Margin/MainPanel/Margin/VBox/HBox/Money
@onready var ItemFlow = $Margin/MainPanel/Margin/VBox/Tabs/小道具/MarginContainer/ScrollContainer/MarginContainer/ItemsFlow
@onready var VenueFlow = $Margin/MainPanel/Margin/VBox/Tabs/场地/MarginContainer/ScrollContainer/MarginContainer/VenueFlow


func ShowShop():
	visible = true
	var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await ani.tween_property(self, "position:y", 0, 0.5).finished

func LoadShopGpusEvent(PGPUC:Array[PackedScene]):
	ClearGpusView()
	UpdataGPU()
	UpdataItems()
	UpdataVenue()
	for i in PGPUC:
		var GPUC = i.instantiate() as GpuCard
		var c:GpuBuyCard = preload("uid://dsu63qljmr3un").instantiate()
		c.LoadInit(GPUC)
		GPUFlow.add_child(c)
		

func _ready() -> void:
	position.y = get_viewport_rect().size.y*-1
	Money.text = tr("当前持有资金: ￥%s") % Global.Money
	SignalNode.OpenShop.connect(ShowShop)
	SignalNode.PastOneDay.connect(UpdataGPU)
	UpdataGPU()
	UpdataItems()
	UpdataVenue()

func BuyItem(GPUC: GpuCard, s:GpuBuyCard):
	Money.text = tr("当前持有资金: ￥%s") % Global.Money
	if Global.Money < GPUC.MarketPrice:
		SignalNode.ShowMoneyErrorMessageBox.emit(GPUC.Model)
		return
	Global.Money -= GPUC.MarketPrice
	Money.text = tr("当前持有资金: ￥%s") % Global.Money
	GPUC.SetGroup("GPUList")
	Global.HasGpu.append(GPUC)
	s.queue_free()
	SignalNode.ReloadGpuList.emit()

func ClearGpusView():
	if GPUFlow.get_child_count() != 0:
		for i in GPUFlow.get_children():
			i.queue_free()

func ClearItemsView():
	if ItemFlow.get_child_count() != 0:
		for i in ItemFlow.get_children():
			i.queue_free()

func ClearVenuesView():
	if VenueFlow.get_child_count() != 0:
		for i in VenueFlow.get_children():
			i.queue_free()

func UpdataGPU():
	ClearGpusView()
	for i in range(randi_range(20, 80)):
		var c:GpuBuyCard = preload("uid://dsu63qljmr3un").instantiate()
		c.Init(Global.Gpu.values().pick_random())
		c.Buy.connect(BuyItem)
		GPUFlow.add_child(c)

func UpdataItems():
	ClearItemsView()
	for i in Global.Items.values():
		var ic:ItemBuyCard = preload("uid://wwc4mfy0pemf").instantiate()
		ic.Init(i)
		ic.ReloadItemsView.connect(UpdataItems)
		ItemFlow.add_child(ic)

func UpdataVenue():
	ClearVenuesView()
	for i in Global.Venue.values():
		var ic:ItemBuyCard = preload("uid://wwc4mfy0pemf").instantiate()
		ic.InitH(i)
		ic.ReloadVenueView.connect(UpdataVenue)
		VenueFlow.add_child(ic)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ReloadShop") and OS.is_debug_build():
		UpdataGPU()

func _on_exit_pressed() -> void:
	var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	await ani.tween_property(self, "position:y", get_viewport_rect().size.y*-1, 0.5).finished
	visible = false

func _process(delta: float) -> void:
	Money.text = tr("当前持有资金: ￥%s") % Global.Money
