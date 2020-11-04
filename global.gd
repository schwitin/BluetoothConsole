extends Node

signal connected
signal disconnected
signal data_received

var bluetooth

func _ready():
	if(Engine.has_singleton("GodotBluetooth")):
		bluetooth = Engine.get_singleton("GodotBluetooth")
		bluetooth.init(get_instance_id(), true)
		print("---------BT OK -------------")
	else:
		print("---------BT NOT INITIALIZED -------------")

#GodotBluetooth Callbacks
func _on_connected(device_name, device_adress):
	emit_signal("connected")
	pass

func _on_disconnected():
	emit_signal("disconnected")
	pass

func _on_data_received(data_received):
	emit_signal("data_received", data_received)
	pass
