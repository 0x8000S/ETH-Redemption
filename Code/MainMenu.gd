extends Control

@export var GameViews:Node
@export var SaveNode:SaveLoadNode
@onready var TabView:TabContainer = $Panel/HBoxContainer/TabViews/TabContainer
@onready var TranslationChanged = $Panel/HBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/VBoxContainer/TranslationChanged


func _ready() -> void:
	print(OS.get_locale())
	TabView.scale = Vector2(0, 0)
	SignalNode.LoadWorld.connect(LoadNewWorldEvent)
	SignalNode.SaveBack.connect(SaveBackEvent)
	if TranslationServer.get_locale() == "zh_CN":
		TranslationServer.set_locale("")
	else:
		TranslationServer.set_locale("en_US")
	if not FileAccess.file_exists("user://LanguageSetting.tres"):
		var ls = LanguageSetting.new()
		ls.Language = TranslationServer.get_locale()
		ResourceSaver.save(ls, "user://LanguageSetting.tres")
	var ls = ResourceLoader.load("user://LanguageSetting.tres") as LanguageSetting
	if ls.Language == "zh_CN":
		TranslationChanged.selected = 0
	elif ls.Language == "en_US":
		TranslationChanged.selected = 1
	TranslationServer.set_locale(ls.Language)

func SaveBackEvent():
	SaveNode.SaveToFile(Global.LoadedWorld)
	EntranceAnimation()
	Global.Rest()
	for i in GameViews.get_children():
		if i is Control:
			i.queue_free()
	await get_tree().create_timer(5).timeout
	TabView.LoadWorldPageInit()

func LoadNewWorldEvent(WorldName:String):
	Global.Rest()
	for i in GameViews.get_children():
		if i is Control:
			i.free()
	var mg = preload("uid://b1kegvnfo88v5").instantiate()
	var sg = preload("uid://c2l2fnou7nd7c").instantiate()
	GameViews.add_child(mg)
	GameViews.add_child(sg)
	sg.visible = false
	ExitAnimation()
	SaveNode.LoadToFile(WorldName)

func ExitAnimation():
	var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	await ani.tween_property(self, "position:y", get_rect().size.y*-1, 0.5).finished
	visible = false

func EntranceAnimation():
	visible = true
	var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await ani.tween_property(self, "position:y", 0, 0.5).finished

func SaveGame():
	print("Saveing...")
	SaveNode.SaveToFile("exa")

# func _input(event: InputEvent) -> void:
# 	if Input.is_action_just_pressed("Save"):
# 		call_deferred("SaveGame")
# 	if Input.is_action_just_pressed("Load"):
# 		SaveNode.LoadToFile("exa")


func SwitchShow(page:int):
	if page != TabView.current_tab:
		var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		await ani.tween_property(TabView, "scale", Vector2(0, 0), 0.5).finished
		TabView.current_tab = page
	var ani:Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	ani.tween_property(TabView, "scale", Vector2(1, 1), 0.5)

func WhenNewWordButtonClicked() -> void:
	SwitchShow(0)


func WhenLoadButtonClicked() -> void:
	SwitchShow(1)

func WhenExitButtonClikced() -> void:
	get_tree().quit()


func WhenInfoButtonClicked() -> void:
	SwitchShow(2)


func WhenTranslationChangedIitemSelected(index: int) -> void:
	var ls = LanguageSetting.new()
	match index:
		0:
			ls.Language = "zh_CN"
			TranslationServer.set_locale("")

		1:
			ls.Language = "en_US"
			TranslationServer.set_locale("en_US")
	TabView.LoadWorldPageInit()
	ResourceSaver.save(ls, "user://LanguageSetting.tres")
