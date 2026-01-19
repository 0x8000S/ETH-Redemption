extends Node

class_name GpuCard
##显卡名称
@export var Model:String
##基础算力(Mh/s)
@export var BaseHashrate:float
##默认TDP(W)
@export var DefaultPower:int
##显卡体质-最大
@export_range(0,1) var MaxQuality:float
##显卡体质-最小
@export_range(0,1) var MinQuality:float
##显卡核心频率
@export var CoreBoost:int
##显卡显存频率
@export var MenBoost:int
##显卡显存(G)
@export var Vram:int
##显卡显存类型
@export var VramType:Global.MenType
##显卡是否锁算力
@export var LHR:bool
##老化
@export_range(0.1,1) var Health:float = 1
##商店价格
@export var MarketPrice:int
##BIOS情况
@export_storage var BiosModded = false
##核心超频偏移
@export_storage var OCCore:float = 0.0
## 显存超频偏移
@export_storage var OCMem:float = 0.0
## 降压
@export_storage var OffsetVolt:int = 0
## 体质
@export_storage var Quality:float
## 核心超频时影响老化加成
@export_storage var OCAgingCoefficient:float = 0.0
## 显存超频时影响老化加成
@export_storage var OCMenAgingCoefficient:float = 0.0
## 超频时影响耗电
@export_storage var OCPowerCoefficient:int = 0
## 超频过度影响的性能发挥系数
@export_storage var PerformanceCoefficient:float = 1.0
## 随机一天暴毙
@export_storage var RandomDamage = false
## 寿命=0暴毙
@export_storage var Old:float = 1.0
## 暴毙bool变量
@export_storage var Broken:bool = false
## 核心最大超频数值
@export_storage var OCCoreLimit = CoreBoost * (0.08 + Quality * 0.07)
@export_storage var OCCoreRedLimit = CoreBoost * (0.08 + Quality * 0.1)
## 显存最大超频数值
@export_storage var OCMenLimit = MenBoost * (Global.MenSafeMap[VramType] - 0.01 + Quality * 0.02)
@export_storage var OCMenRedLimit = MenBoost * (Global.MenRedMap[VramType] - 0.01 + Quality * 0.02)
## 最大降压
@export_storage var OVLimit = 150 * Quality
## 工作时间
@export_storage var WorkHours:int = 0
@export_storage var OnBoard = false
@export_storage var OverLineCore = false
@export_storage var OverLineMen = false
@export_storage var Edit:bool = false
var Vars = [Model, BaseHashrate, DefaultPower, MaxQuality, MinQuality, CoreBoost, MenBoost, Vram, VramType, LHR, Health, MarketPrice, BiosModded, OCCore, OCMem, OffsetVolt, Quality, OCAgingCoefficient, OCMenAgingCoefficient, OCPowerCoefficient, PerformanceCoefficient, RandomDamage, Old, Broken, OCCoreLimit, OCCoreRedLimit, OCMenLimit, OCMenRedLimit, OVLimit, WorkHours, OnBoard, OverLineCore, OverLineMen, Edit]


func _ready() -> void:
	add_to_group("GPUList")

func SetGroup(GroupName:String):
	var groups = ["GPUList", "GPUBuy", "GPUListOnBoard"]
	for i in groups:
		remove_from_group(i)
	add_to_group(GroupName)
## 超频完成后调用
func CalcOcLimit():
	OCCoreLimit = CoreBoost * (0.08 + Quality * 0.07)
	OCCoreRedLimit = CoreBoost * (0.08 + Quality * 0.1)
	## 显存最大超频数值
	OCMenLimit = MenBoost * (Global.MenSafeMap[VramType] - 0.01 + Quality * 0.02)
	OCMenRedLimit = MenBoost * (Global.MenRedMap[VramType] - 0.01 + Quality * 0.02)

	print("OC: %s\nOCR: %s\nOM: %s\nOMR: %s" % [OCCoreLimit, OCCoreRedLimit, OCMenLimit, OCMenRedLimit])
	OVLimit = 150 * Quality
	var OverFull = false
	PerformanceCoefficient = 1.0
	OCPowerCoefficient = 0
	OCMenAgingCoefficient = 0
	if OCCore >= OCCoreLimit:
		PerformanceCoefficient = maxf(1-0.01*(OCCore-OCCoreLimit)+0.01, 0.45)
		OCPowerCoefficient += int((OCCore-OCCoreLimit)*0.5)
		OverFull = true
		if OCCoreRedLimit <= OCCore and OverLineCore == false:
			OverLineCore = true
			BaseHashrate = maxf(BaseHashrate-(OCCore-OCCoreLimit)*0.02, 0)
			OCPowerCoefficient += int((OCCore-OCCoreLimit)*2)
			Old -= 0.01
			RandomDamage = true
	if (OCMem + OCMem) >= OCMenLimit:
		OCPowerCoefficient += int(OCMem-OCMenLimit)*2
		OCMenAgingCoefficient += int((OCMem-OCMenLimit)*0.2)
		OverFull = true
		if OCMenRedLimit  <= (OCMem + OCMem) and OverLineMen == false:
			OverLineMen = true
			BaseHashrate = maxf(BaseHashrate-(OCMem-OCMenLimit)*0.04, 0)
			OCPowerCoefficient += int(OCMem-OCMenLimit)*4
			Old -= 0.2
			RandomDamage = true
	if not OverFull:
		PerformanceCoefficient = 1.0
		OCPowerCoefficient = 0
		OCMenAgingCoefficient = 0
		RandomDamage = false
	if Broken or Old == 0:
		Broken = true
	SignalNode.UpdataShowText.emit(self)

## 获取算力
func GetHashrate() -> float:
	var Hash:float = float("%.2f" % (BaseHashrate * (1-(float(OffsetVolt)/150)*0.12+(OCMem/2500)*0.15+(OCCore/2000)*0.2-(Quality/100)*0.01-(Health/150)*0.015) * PerformanceCoefficient))
	if Broken or Old == 0:
		return 0.0
	if LHR:
		Hash *= 0.6
	return Hash

## 获取功耗
func GetPower() -> int:
	var power:int = int(DefaultPower * (1 - (OCMem/4000) * 0.1 + (OCCore/2000) * 0.15 - (float(OffsetVolt)/150) * 0.12)) + OCPowerCoefficient + 10-Old*10
	if OnBoard and Global.MainBoardPowerState and Broken == false:
		power += randi_range(1, 8)
	if not Global.HasItems.has(Global.Items.GetPower) and OnBoard and not Global.MainBoardPowerState:
		return 0
	return power

func Aging():
	Old = maxf(Old-(0.002*Quality+0.004+Old*0.004), 0)
	Health = maxf(Health-(0.001*Quality+(OCMenAgingCoefficient+OCAgingCoefficient)*0.002+0.001), 0.1)

func Init(sours:Array):
	for i in Vars:
		i = sours

func GetData() -> Array:
	return [Model, BaseHashrate, DefaultPower, MaxQuality, MinQuality, CoreBoost, MenBoost, Vram, VramType, LHR, Health, MarketPrice, BiosModded, OCCore, OCMem, OffsetVolt, Quality, OCAgingCoefficient, OCMenAgingCoefficient, OCPowerCoefficient, PerformanceCoefficient, RandomDamage, Old, Broken, OCCoreLimit, OCCoreRedLimit, OCMenLimit, OCMenRedLimit, OVLimit, WorkHours, OnBoard, OverLineCore, OverLineMen, Edit]