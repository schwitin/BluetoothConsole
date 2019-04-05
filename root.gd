extends Node


func _ready():
	global.connect("connected", self, "_on_connected")
	global.connect("disconnected", self, "_on_disconnected")
	global.connect("data_received", self, "_on_data_received")
	
	var node = get_node("Panel/HBoxContainer/VBoxContainer/TextEdit")
	node.set_wrap(true)
	node.set_readonly(true)
	
	var fileDialog = get_node("Panel/HBoxContainer/VBoxFile/FileDialog")
	fileDialog.set_current_dir(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS))
	
	var itemList = get_node("Panel/HBoxContainer/VBoxFile/ScrollContainer/ItemList")
	itemList.add_item("bla")
	
	var scrollBarV = itemList.get_child(0);
	scrollBarV.set_scale(Vector2(5.0,1.0))
	write_file()
	
func write_file():
	var file = File.new()
	file.open("user://example1.txt", File.WRITE)
	file.store_line("bla_bla")
	file.close()

func _on_disconnected():
	get_node("Panel/HBoxContainer/VBoxContainer/ConnectDisconnect").set_text("Maschine verbinden")
	get_node("Panel/HBoxContainer/VBoxContainer/HBoxContainer/Senden").set_disabled(true);
	
func _on_connected():
	get_node("Panel/HBoxContainer/VBoxContainer/ConnectDisconnect").text = "Verbindung beenden"
	get_node("Panel/HBoxContainer/VBoxContainer/HBoxContainer/Senden").set_disabled(false);

func _on_data_received(data):
	var node = get_node("Panel/HBoxContainer/VBoxContainer/TextEdit")
	var text = node.get_text()
	node.set_text(data + "\n" + text)
	#node.cursor_set_line(node.get_line_count(), true)
	#node.cursor_set_column(0)

func _on_ConnectDisconnect_pressed():
	var a = global
	if global.bluetooth:
		global.bluetooth.getPairedDevices(true)


func _on_Senden_pressed():
	var text = get_node("Panel/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit").get_text()
	if global.bluetooth:
		global.bluetooth.sendData("{" + text + "}")
		get_node("Panel/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit").set_text("")
	


func _on_OpenFile_pressed():
	var fileDialog = get_node("Panel/HBoxContainer/VBoxFile/FileDialog")
	fileDialog.popup_centered()


func _on_FileDialog_file_selected( path ):
	var file = File.new()
	if file.open(path, File.READ) != 0:
		print("Error opening file")
		return
	
	var itemList = get_node("Panel/HBoxContainer/VBoxFile/ScrollContainer/ItemList")
	itemList.clear()
	while !file.eof_reached():
		itemList.add_item(file.get_line())
	

func _on_ButtonN_pressed():
	
	var itemList = get_node("Panel/HBoxContainer/VBoxFile/ScrollContainer/ItemList")
	var count = itemList.get_item_count()
	
	var selectedArray = itemList.get_selected_items()
	if selectedArray.size() > 0:
		var selectedIdx = selectedArray[0]
		if selectedIdx < count - 2:
			itemList.select(selectedIdx+1)
			itemList.ensure_current_is_visible()
			var value = itemList.get_item_text(selectedIdx+1)
			get_node("Panel/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit").set_text(value)

func _on_ButtonP_pressed():
	var itemList = get_node("Panel/HBoxContainer/VBoxFile/ScrollContainer/ItemList")
	var count = itemList.get_item_count()
	
	var selectedArray = itemList.get_selected_items()
	if selectedArray.size() > 0:
		var selectedIdx = selectedArray[0]
		if selectedIdx > 0:
			itemList.select(selectedIdx-1)
			itemList.ensure_current_is_visible()
			var value = itemList.get_item_text(selectedIdx-1)
			get_node("Panel/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit").set_text(value)


func _on_ItemList_item_selected( index ):
	var itemList = get_node("Panel/HBoxContainer/VBoxFile/ScrollContainer/ItemList")
	var value = itemList.get_item_text(index)
	get_node("Panel/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit").set_text(value)
