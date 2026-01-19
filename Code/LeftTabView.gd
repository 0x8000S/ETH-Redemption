extends Panel

@onready var GpuList:VBoxContainer = $TabContainer/显卡/GPUVSplit/GPUListScrollView/VBoxContainer/CardPut/VBoxContainer

func ClearGpuList():
	for i in GpuList.get_children():
		i.queue_free()

func UpdataGpuList():
	ClearGpuList()
	for g in Global.HasGpu:
		var gi:GPUItem = preload("uid://boxqa4tpeslwf").instantiate()
		g.OnBoard = false
		GpuList.add_child(gi)
		gi.Iint(g)
		gi.add_to_group("GPUItems")
		gi.remove_from_group("GPUItemsOnBoard")
func SetGpuOnBoard(value:bool):
	for i:GPUItem in GpuList.get_children():
		i.Gpu.OnBoard = value
func LoadGpuListEvent(Gpus:Array[PackedScene]):
	ClearGpuList()
	for i:PackedScene in Gpus:
		var gi:GPUItem = preload("uid://boxqa4tpeslwf").instantiate()
		var g = i.instantiate() as GpuCard
		GpuList.add_child(gi)
		gi.Iint(g)
		Global.HasGpu.append(g)
func _ready() -> void:
	UpdataGpuList()
	SignalNode.ReloadGpuList.connect(UpdataGpuList)
	SignalNode.PastOneHour.connect(func():SetGpuOnBoard(false))
	SignalNode.LoadGpuList.connect(LoadGpuListEvent)
	SignalNode.LoadSaveFile.connect(ClearGpuList)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DebugAddMoney") and OS.is_debug_build():
		Global.Money += 500

func _on_button_pressed() -> void:
	SignalNode.OpenShop.emit()
