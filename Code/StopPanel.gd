extends CenterContainer

@onready var Context = $PanelContainer/MarginContainer/VBoxContainer/Context

func _ready() -> void:
	position.y = get_viewport_rect().size.y
	visible = false
	SignalNode.Stop.connect(StopEvent)

func _process(delta: float) -> void:
	if visible:
		Context.text = tr("已过去\n%s 年\n%s 月\n%s 日\n%s 小时\n总资产: ￥%s") % [Global.YearCount, Global.MoonCount, Global.DayCount, Global.HourCount, Global.Money]
	if Input.is_action_just_pressed("Stop"):
		StopEvent()

func StopEvent():
	TimeNode.HoursTimer.stop()
	get_tree().paused = true
	visible = true
	var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	ani.tween_property(self, "position:y", 0, 0.5)

func WhenContinueButtonClicked() -> void:
	get_tree().paused = false
	var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	await ani.tween_property(self, "position:y", get_viewport_rect().size.y, 0.5).finished
	visible = false

func WhenSaveExitButtonClicked() -> void:
	WhenContinueButtonClicked()
	SignalNode.SaveBack.emit()
