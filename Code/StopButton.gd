extends Button

func WhenStopButtonClicked() -> void:
	SignalNode.Stop.emit()
