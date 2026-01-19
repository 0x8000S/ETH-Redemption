extends Node

signal OpenShop
signal EditGPU(GPUC:GpuCard)
signal PastOneHour
signal PastOneDay
signal PickUPGPU(GPUCl:GpuCard)
signal ReloadGpuList
signal UpdataMainBoardText
signal UnPickUPGPU
signal PriceChanged(Price : float)
signal UpdataMoney
signal PastOneDayMoneyCount(ETH:float, Power:float)
signal OCGPU(GPUC:GpuCard, GPUI:GPUItem)
signal UpdataShowText(GPUC:GpuCard)
signal UnEditGPU(GPUC:GpuCard)
signal PastOneMoon
signal PastOneYear
signal PowerUpMainBoard
signal PowerDownMainBoard
signal InfoMainBoard(MaxGpus:int, SumMHS:float, MaxPower:int)
signal ShowMoneyErrorMessageBox(Contexts:String)
signal ShowCustomMessageBox(Title:String, Context:String, Level)
signal ShowSellMessageBox(GPUC:GpuCard)
signal ShowFixMessageBox(GPUC:GpuCard)
signal SwitchVenue(venue:Global.Venue)
signal ClearMainBoardAllGpu()
signal UpdateMainBoardMaxGpu(MaxGpu:int)
signal ChangedMainBoardPowerState(Power:bool)
signal LoadGpuList(Gpus:Array[PackedScene])
signal LoadSaveFile
signal LoadMainBoardGpus(Gpus:Array[PackedScene], State:bool)
signal LoadShopGpus(Gpus:Array[PackedScene])
signal SyncTimeZoomValue
signal ShowDelWorldMessageBox(WorldName:String)
signal DelWorld
signal LoadWorld(WorldName:String)
signal SaveBack
signal Stop
signal CheckGpu(EGPU:Global.Gpu)