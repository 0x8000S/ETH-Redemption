extends Node

var price := 20000.0          # 初始基准 20000 USDT
var index := 1.0              #  normalized 指数
const INTERVAL := 10.0        # 秒
const VOLATILITY := 0.015     # 1.5 % 标准差
const MEAN_REVERT := 0.05     # 回归力度
var timer := Timer.new()

func _ready():
    # _on_tick()
    # timer.wait_time = INTERVAL
    # timer.timeout.connect(_on_tick)
    # add_child(timer)
    # timer.start()
    SignalNode.PastOneHour.connect(Updata)
    SignalNode.PastOneDay.connect(UpdataETH)
    Updata()

func Updata():
    # 1. 高斯随机步
    var rnd = randf_range(-1.0, 1.0) * VOLATILITY
    # 2. 回归中心
    var revert = (1.0 - index) * MEAN_REVERT
    index += rnd + revert
    index = clamp(index, 0.5, 4.0)   # 地板 0.5 封顶 4 倍
    price = 20000.0 * index
    SignalNode.PriceChanged.emit(price/10)

func UpdataETH():
    Global.BaseHourETH = Global.BaseETH
    var rf = randf()
    if rf >= 0.6 and Global.ETHMoney >= 0.0002:
        Global.BaseHourETH = Global.BaseETH * (minf(randf()+0.4, 1.2))
        print(">.< -> %s" % Global.BaseHourETH)