extends Node

var logList
var fileDialog
var fileDialogDateiSenden
var itemList
var lineEdit
var btnConnectDisconnect
var btnSenden
var btnSendenDatei

func _ready():
	global.connect("connected", self, "_on_connected")
	global.connect("disconnected", self, "_on_disconnected")
	global.connect("data_received", self, "_on_data_received")
	
	logList = get_node("HBoxContainer/VBoxContainer/LogList")	
	
	fileDialog = get_node("FileDialog")
	fileDialog.set_current_dir(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS))
	fileDialogDateiSenden = get_node("FileDialogDateiSenden")
	fileDialogDateiSenden.set_current_dir(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS))
	
	itemList = get_node("HBoxContainer/VBoxFile/ScrollContainer/ItemList")
	lineEdit = get_node("HBoxContainer/VBoxContainer/HBoxContainer/LineEdit")
	btnConnectDisconnect = get_node("HBoxContainer/VBoxContainer/ConnectDisconnect")
	btnSenden = get_node("HBoxContainer/VBoxContainer/HBoxContainer/Senden")
	btnSendenDatei = get_node("HBoxContainer/VBoxContainer/HBoxContainer/SendenDatei")


func _on_disconnected():
	btnConnectDisconnect.set_text("Maschine verbinden")
	btnSenden.set_disabled(true);
	btnSendenDatei.set_disabled(true);


func _on_connected():
	btnConnectDisconnect.text = "Verbindung beenden"
	btnSenden.set_disabled(false);
	btnSendenDatei.set_disabled(false);


func _on_data_received(data):
	self.logList.add_item(data, null, false)
	self.logList.move_item (self.logList.get_item_count()-1, 0)
	self.logList.set_item_tooltip_enabled(0, false)
	self.logList.remove_item(20)


func _on_ConnectDisconnect_pressed():
	if global.bluetooth:
		global.bluetooth.getPairedDevices(true)


func _on_Senden_pressed():
	var text = lineEdit.get_text()
	if global.bluetooth:
		global.bluetooth.sendData("{" + text + "}")
		lineEdit.set_text("")


func _on_SendenDatei_pressed():
	fileDialogDateiSenden.popup_centered()


func _on_OpenFile_pressed():
	fileDialog.popup_centered()


func _on_FileDialog_file_selected( path ):
	var file = File.new()
	if file.open(path, File.READ) == 0:
		itemList.clear()
		while !file.eof_reached():
			itemList.add_item(file.get_line())


func _on_FileDialogDateiSenden_file_selected(path):	
	var file = File.new()     
	if global.bluetooth && file.open(path, File.READ) == 0:
		var fileInhalt = file.get_as_text()
		var command = lineEdit.get_text()
		global.bluetooth.sendData("{" + command + fileInhalt + "}")
		lineEdit.set_text("")


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




