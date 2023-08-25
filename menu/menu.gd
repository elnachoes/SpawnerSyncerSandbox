class_name Menu
extends VBoxContainer

signal host_pressed(port: int, max_players: int, headless: bool)
signal connect_pressed(address: String, port: int)

@onready var host_button := $HostButton as Button
@onready var headless_button := $HeadlessButton as Button
@onready var connect_button := $ConnectButton as Button

@onready var max_players_field := $MaxPlayers/MaxPlayersField as SpinBox
@onready var address_field := $Address/AddressField as LineEdit
@onready var port_field := $Port/PortField as SpinBox


func _ready():
	host_button.pressed.connect(_on_host_button_pressed)
	headless_button.pressed.connect(_on_headless_button_pressed)
	connect_button.pressed.connect(_on_connect_button_pressed)
	
	if OS.get_cmdline_args().has("server") || DisplayServer.get_name() == "headless":
		_on_headless_button_pressed()


func _on_host_button_pressed():
	host_pressed.emit(int(port_field.value), int(max_players_field.value), false)


func _on_headless_button_pressed():
	host_pressed.emit(int(port_field.value), int(max_players_field.value), true)


func _on_connect_button_pressed():
	connect_pressed.emit(address_field.text, int(port_field.value))
