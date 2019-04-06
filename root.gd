extends Node

var textEdit
var fileDialog
var itemList
var lineEdit
var btnConnectDisconnect
var btnSenden

func _ready():
	global.connect("connected", self, "_on_connected")
	global.connect("disconnected", self, "_on_disconnected")
	global.connect("data_received", self, "_on_data_received")
	
	textEdit = get_node("Panel/HBoxContainer/VBoxContainer/TextEdit")
	textEdit.set_wrap(true)
	textEdit.set_readonly(true)
	
	fileDialog = get_node("Panel/HBoxContainer/VBoxFile/FileDialog")
	fileDialog.set_current_dir(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS))
	
	itemList = get_node("Panel/HBoxContainer/VBoxFile/ScrollContainer/ItemList")
	lineEdit = get_node("Panel/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit")
	btnConnectDisconnect = get_node("Panel/HBoxContainer/VBoxContainer/ConnectDisconnect")
	btnSenden = get_node("Panel/HBoxContainer/VBoxContainer/HBoxContainer/Senden")


func _on_disconnected():
	btnConnectDisconnect.set_text("Maschine verbinden")
	btnSenden.set_disabled(true);


func _on_connected():
	btnConnectDisconnect.text = "Verbindung beenden"
	btnSenden.set_disabled(false);


func _on_data_received(data):
	var text = textEdit.get_text()
	textEdit.set_text(data + "\n" + text)


func _on_ConnectDisconnect_pressed():
	var a = global
	if global.bluetooth:
		global.bluetooth.getPairedDevices(true)


func _on_Senden_pressed():
	var text = lineEdit.get_text()
	if global.bluetooth:
		global.bluetooth.sendData("{" + text + "}")
		lineEdit.set_text("")


func _on_OpenFile_pressed():
	fileDialog.popup_centered()


func _on_FileDialog_file_selected( path ):
	var file = File.new()
	if file.open(path, File.READ) == 0:
		itemList.clear()
		while !file.eof_reached():
			itemList.add_item(file.get_line())


func _on_ButtonN_pressed():
	var count = itemList.get_item_count()
	var selectedArray = itemList.get_selected_items()
	if selectedArray.size() > 0:
		var selectedIdx = selectedArray[0]
		if selectedIdx < count - 2:
			selectItem(selectedIdx+1)


func _on_ButtonP_pressed():
	var selectedArray = itemList.get_selected_items()
	if selectedArray.size() > 0:
		var selectedIdx = selectedArray[0]
		if selectedIdx > 0:
			selectItem(selectedIdx-1)


func selectItem(idx):
	itemList.select(idx)
	itemList.ensure_current_is_visible()
	_on_ItemList_item_selected(idx)


func _on_ItemList_item_selected( index ):
	var value = itemList.get_item_text(index)
	lineEdit.set_text(value)
