extends HBoxContainer

@onready var ZoomText = $MainPanel/MarginContainer/Zoom
var TimeZoomValue:Array[float] = [0.5, 1.0, 2.0, 3.0, 4.0, 8.0, 10.0]
var index = 1

func SyncTimeZoomValue():
	$State.text = "○"
	TimeNode.HoursTimer.start()
	index = TimeZoomValue.find(Global.ZoomValue)
	ZoomText.text = "x %s" % TimeZoomValue[index]

func WhenLessButtonClicked() -> void:
	if index != 0:
		index -= 1
		Global.ZoomValue = TimeZoomValue[index]
		ZoomText.text = "x %s" % TimeZoomValue[index]


func WhenFastButtonClicked() -> void:
	if index != len(TimeZoomValue) - 1:
		index += 1
		Global.ZoomValue = TimeZoomValue[index]
		ZoomText.text = "x %s" % TimeZoomValue[index]


func WhenStateButtonClicked() -> void:
	if $State.text == "●":
		$State.text = "○"
		TimeNode.HoursTimer.start()
	else:
		$State.text = "●"
		TimeNode.HoursTimer.stop()

func _ready() -> void:
	SignalNode.SyncTimeZoomValue.connect(SyncTimeZoomValue)
