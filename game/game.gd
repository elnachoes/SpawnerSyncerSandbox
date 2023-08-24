extends Node

@onready var multiplayer_spawner = $"MultiplayerSpawner"
@onready var player_spawn_location = $"PlayerSpawnLocation"
@onready var player_spawn = $"PlayerSpawn"
@onready var net_id_label = $"ConnectionMenu/HBoxContainer/NetIdLabel"
@onready var ip_address_input = $"ConnectionMenu/HBoxContainer/VBoxContainer/IpAddress"
@onready var port_input = $"ConnectionMenu/HBoxContainer/VBoxContainer/Port"

const MAX_CLIENTS = 4

var player_scene = load("res://player/player.tscn")

var players = []

func _ready():
	if OS.get_cmdline_args().find("server") != -1:
		create_server()

# setup a server and the nessesary events and set the label text
func create_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(int(port_input.text), MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(handle_client_connected)
	multiplayer.peer_disconnected.connect(handle_client_disconnected)
	net_id_label.text = "Server"

func create_player(id : int):
	var player = player_scene.instantiate()
	players.append(player)
	player.name = "player_%s" % id
	player.assigned_net_id = id
	player.position = player_spawn_location.position
	player_spawn.call_deferred("add_child", player)

func _on_host_button_pressed():
	create_server()

# create client and set label text
func _on_connect_button_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address_input.text, int(port_input.text))
	multiplayer.multiplayer_peer = peer
	net_id_label.text = "Client Net Id : %s" % multiplayer.get_unique_id()

func _on_host_as_player_pressed():
	create_server()
	create_player(1)

# whenever a client connects spawn a new player
# this will only ever be called on the server
func handle_client_connected(id : int):
	create_player(id)

# whenever a client disconnects remove that player
# this will only ever be called on the server
func handle_client_disconnected(id : int):
	if multiplayer.is_server():
		for player in players:
			if player.assigned_net_id == id:
				player.free()
				players.remove_at(players.find(player))
