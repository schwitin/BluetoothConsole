extends Node


func _ready():
	global.connect("connected", self, "_on_connected")
	global.connect("disconnected", self, "_on_disconnected")
	global.connect("data_received", self, "_on_data_received")
	
	var node = get_node("Panel/VBoxContainer/TextEdit")
	node.set_wrap(true)
	node.set_readonly(true)

func _on_disconnected():
	get_node("Panel/VBoxContainer/ConnectDisconnect").set_text("Maschine verbinden")
	get_node("Panel/VBoxContainer/Senden").set_disabled(true);
	
func _on_connected():
	get_node("Panel/VBoxContainer/ConnectDisconnect").text = "Verbindung beenden"
	get_node("Panel/VBoxContainer/HBoxContainer/Senden").set_disabled(false);

func _on_data_received(data):
	var node = get_node("Panel/VBoxContainer/TextEdit")
	var text = node.get_text()
	node.set_text(text + "\n" + data)
	node.cursor_set_line(node.get_line_count(), true)
	node.cursor_set_column(0)

func _on_ConnectDisconnect_pressed():
	var a = global
	if global.bluetooth:
		global.bluetooth.getPairedDevices(true)
	else:
		get_node("Panel/VBoxContainer/SendeStatus").set_text("Bluetooth Fehler")


func _on_Senden_pressed():
	var text = get_node("Panel/VBoxContainer/HBoxContainer/LineEdit").get_text()
	if global.bluetooth:
		global.bluetooth.sendData("{" + text + "}")
		get_node("Panel/VBoxContainer/HBoxContainer/LineEdit").set_text("")
	
