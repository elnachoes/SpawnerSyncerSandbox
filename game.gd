extends Node

@onready var multiplayer_spawner = $"MultiplayerSpawner"
@onready var player_spawn_location = $"PlayerSpawnLocation"
@onready var player_spawn = $"PlayerSpawn"
@onready var net_id_label = $"ConnectionMenu/HBoxContainer/NetIdLabel"

const PORT = 9009
const IP_ADDRESS = "127.0.0.1"
const MAX_CLIENTS = 3

var player_scene = load("res://player.tscn")

var players = []

func _ready():
	if OS.get_cmdline_args().find("server") != -1:
		create_server()

func create_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(handle_client_connected)
	multiplayer.peer_disconnected.connect(handle_client_disconnected)
	net_id_label.text = "Server"

# create server
func _on_host_button_pressed():
	create_server();

# create client
func _on_connect_button_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	net_id_label.text = "Client Net Id : %s" % multiplayer.get_unique_id()

# whenever a client connects spawn a new player
func handle_client_connected(id : int):
	var player = player_scene.instantiate()
	players.append(player)
	player.name = "player_%s" % id
	player.assigned_net_id = id
	player.position = player_spawn_location.position
	player_spawn.call_deferred("add_child", player)
	
# whenever a client disconnects remove that player
func handle_client_disconnected(id : int):
	if multiplayer.is_server():
		for player in players:
			if player.assigned_net_id == id:
				player.free()
				players.remove_at(players.find(player))
