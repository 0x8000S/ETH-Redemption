extends PanelContainer

func Init(text:String):
	$MarginContainer/Label.text = text
	var ani:Tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	await ani.tween_property(self, "position:x", get_viewport_rect().size.x - GetWordCount() * 10 - 20, 0.5).finished
	await get_tree().create_timer(1).timeout
	ani = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	await ani.tween_property(self, "position:x", 2000, 0.5).finished
	queue_free()

func GetWordCount() -> int:
	print(len($MarginContainer/Label.text))
	return len($MarginContainer/Label.text)