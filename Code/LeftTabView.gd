extends Panel

@onready var GpuList:VBoxContainer = $TabContainer/显卡/GPUVSplit/GPUListScrollView/VBoxContainer/CardPut/VBoxContainer

func UpdataGpuList():
	for i in GpuList.get_children():
		i.queue_free()
	for g in Global.HasGpu:
		var gi:GPUItem = preload("uid://boxqa4tpeslwf").instantiate()
		GpuList.add_child(gi)
		gi.Iint(g)
		

func _ready() -> void:
	UpdataGpuList()
	SignalNode.ReloadGpuList.connect(UpdataGpuList)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Reload"):
		UpdataGpuList()


func _on_button_pressed() -> void:
	SignalNode.OpenShop.emit()
