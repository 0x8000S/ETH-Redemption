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
signal ShowCustomMessageBox(Title:String, Context:String)
signal ShowSellMessageBox(GPUC:GpuCard)
signal ShowFixMessageBox(GPUC:GpuCard)