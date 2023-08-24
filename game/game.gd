extends Node

@onready var menu := $Menu as Menu
@onready var player_spawn_location = $"PlayerSpawnLocation"
@onready var player_spawn = $"PlayerSpawn"

const MAX_CLIENTS = 4

var player_scene = load("res://player/player.tscn")


func _ready():
	menu.host_pressed.connect(create_server)
	menu.connect_pressed.connect(create_client)


func create_server(port: int, max_players: int, headless: bool):
	var max_clients = max_players - 1
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port, max_clients)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(handle_client_connected)
	multiplayer.peer_disconnected.connect(handle_client_disconnected)
	if not headless:
		create_player(1)
	menu.hide()


func create_client(address: String, port: int):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	multiplayer.multiplayer_peer = peer
	multiplayer.server_disconnected.connect(handle_server_disconnected)
	menu.hide()


func create_player(id: int):
	var player = player_scene.instantiate() as Player
	player.name = str(id)
	player.assigned_net_id = id
	player.position = player_spawn_location.position
	player_spawn.call_deferred("add_child", player)


func handle_client_connected(id: int):
	create_player(id)


func handle_client_disconnected(id: int):
	if player_spawn.has_node(str(id)):
		player_spawn.get_node(str(id)).queue_free()


func handle_server_disconnected():
	multiplayer.multiplayer_peer = null
	menu.show()
