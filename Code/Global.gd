extends Node

var Money:float = 20000.0
var ETHMoney:float = 0.0
var ElectricityPrice:float = 0.6
var ElectricityPriceCount:float = 0.0
var DayCount:int
var HourCount:int
var MoonCount:int
var YearCount:int
var HasGpu:Array[GpuCard]
var BaseETH:float = 0.000000625
var BaseHourETH:float = 0.000000625
var MainBoardPowerState:bool = false
var HourTime = 2.0
var ZoomValue = 1.0

var FixLevel:Array[bool] = [1, 0, 0, 0]
var FixLevelValue:Dictionary[int,Dictionary] = {
    0: {
        "O": 0.1,
        "H": 0.2
    },
    1: {
        "O": 0.2,
        "H": 0.4
    },
    2: {
        "O": 0.4,
        "H": 0.5,
    },
    3: {
        "O": 0.7,
        "H": 0.7,
        "Q": 0.4
    }
}

enum Items {
    FixLevel1,
    FixLevel2,
    FixLevel3,
    GetPower
}

var ItemsText:Dictionary[Items, String] = {
    Items.FixLevel1: "正常修复",
    Items.FixLevel2: "专业修复",
    Items.FixLevel3: "大师级修复",
    Items.GetPower: "功耗计"
}

var ItemsPrice:Dictionary[Items, float] = {
    Items.FixLevel1: 100.0,
    Items.FixLevel2: 200.0,
    Items.FixLevel3: 500.0,
    Items.GetPower: 120.0
}

var HasItems:Array[Items] = []

func GetHourTime(): 
    return HourTime / ZoomValue

enum MenType {
    GDDR5_8G,
    GDDR5X_8G,
    GDDR6_14G,
    GDDR6X_19G,
    GDDR6X_22G
}

var MenSafeMap:Dictionary[MenType, float] = {
    MenType.GDDR5_8G: 1.16,
    MenType.GDDR5X_8G: 1.16,
    MenType.GDDR6_14G: 1.15,
    MenType.GDDR6X_19G: 1.10,
    MenType.GDDR6X_22G: 1.07
}

var MenRedMap:Dictionary[MenType, float] = {
    MenType.GDDR5_8G: 1.22,
    MenType.GDDR5X_8G: 1.22,
    MenType.GDDR6_14G: 1.20,
    MenType.GDDR6X_19G: 1.15,
    MenType.GDDR6X_22G: 1.12
}

enum Gpu {
    AMD_RX470,
    AMD_RX570,
    AMD_RX580,
    Nvidia_GTX1060,
    Nvidia_GTX1070TI,
    Nvidia_GTX1080TI,
    Nvidia_RTX2060S,
    Nvidia_RTX3060TI_LHR
}