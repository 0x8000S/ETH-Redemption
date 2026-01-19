extends TabContainer

@export var SaveNode:SaveLoadNode
@onready var NewWorldName = $NewWord/MarginContainer/HBoxContainer/LineEdit
@onready var LoadWorldPage = $LoadWrold/VBoxContainer/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer
@onready var GpuInfoViews = $InfoGpu/VBoxContainer/MarginContainer/HBoxContainer/ScrollContainer/MarginContainer/VBoxContainer
@onready var GpuInfo = $InfoGpu/VBoxContainer/MarginContainer/HBoxContainer/Panel/ScrollContainer/MarginContainer/Info

func _ready() -> void:
	LoadWorldPageInit()
	InfoGpuPageInit()
	SignalNode.DelWorld.connect(LoadWorldPageInit)
	SignalNode.LoadSaveFile.connect(LoadWorldPageInit)
	SignalNode.CheckGpu.connect(CheckGpuEvent)

func CheckGpuEvent(EGPU:Global.Gpu):
	var g:GpuCard = GpuGroup.GpuBox[EGPU].instantiate()
	GpuInfo.text = tr("显卡名称: %s\n基础算力: %sMh/s\n频率: %sMHz\n显存: %sG\n显存频率: %sGbps\nTDP: %sW\n市场参考价格: ￥%s\n") % [g.Model, g.BaseHashrate, g.CoreBoost, ("%s-%s" % [Global.MenText[g.VramType], g.Vram]), g.MenBoost/1000, g.DefaultPower, g.MarketPrice]
	g.queue_free()

func InfoGpuPageInit():
	for i in Global.Gpu.values():
		var cg:GPUCheck = preload("uid://cnfeupuifh47e").instantiate()
		GpuInfoViews.add_child(cg)
		cg.Init(i)

func LoadWorldPageInit():
	await get_tree().create_timer(0.1).timeout
	if LoadWorldPage.get_child_count() != 0:
		for i in LoadWorldPage.get_children():
			i.queue_free()
	await get_tree().create_timer(0.5).timeout
	for i in SaveNode.ListSaveFiles():
		var wc:WorldCard = preload("uid://bonkjlw05a46h").instantiate()
		LoadWorldPage.add_child(wc)
		wc.Init(i)

func SwitchShow(page:int):
	if current_tab == 1:
		LoadWorldPageInit()
	if page != current_tab:
		var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		await ani.tween_property(self, "scale", Vector2(0, 0), 0.5).finished
		current_tab = page
	var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	ani.tween_property(self, "scale", Vector2(1, 1), 0.5)

func CreateMessageBox(Mode:String, Text:String):
	var m
	if Mode == "N":
		m = preload("uid://b7xb2d1pkilu1").instantiate()
	elif Mode == "E":
		m = preload("uid://c5nfyuffbedd3").instantiate()
	m.z_index = 100
	get_tree().current_scene.add_child(m)
	m.position = Vector2(2000, 20)
	m.Init(Text)

func WhenCreateButtonClicked() -> void:
	print("a")
	var WorldName:String = NewWorldName.text
	if NewWorldName.text == "":
		CreateMessageBox("E", tr("存档名不可为空白!"))
		return
	if not WorldName.is_valid_filename():
		CreateMessageBox("E", tr("非法的存档名!"))
		return
	if NewWorldName.text in SaveNode.ListSaveFiles():
		CreateMessageBox("E", tr("已有相同的存档!"))
		return
	CreateMessageBox("N", tr("存档创建成功!"))
	SaveNode.SaveToFile(WorldName)
	NewWorldName.text = ""
