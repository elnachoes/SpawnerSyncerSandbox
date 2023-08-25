extends Node

@onready var camera := $MultiTargetCamera as MultiTargetCamera
@onready var menu := $CanvasLayer/Menu as Menu
@onready var player_spawn_location := $PlayerSpawnLocation as Marker2D
@onready var players := $Players as Node

var player_scene = load("res://player/player.tscn") as PackedScene


func _ready():
	menu.host_pressed.connect(create_server)
	menu.connect_pressed.connect(create_client)


func _physics_process(_delta):
	camera.show_all_targets(players.get_children())


func create_server(port: int, max_players: int, headless: bool):
	var max_clients = max_players if headless else max_players - 1
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
	player.input_peer_id = id
	player.position = player_spawn_location.position
	players.add_child(player)


func handle_client_connected(id: int):
	create_player(id)


func handle_client_disconnected(id: int):
	if players.has_node(str(id)):
		players.get_node(str(id)).queue_free()


func handle_server_disconnected():
	multiplayer.multiplayer_peer = null
	menu.show()
