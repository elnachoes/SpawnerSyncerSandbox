extends CharacterBody2D

const SPEED = 300.0

var assigned_net_id = 0

func _physics_process(_delta):
	# if the player is a client send the input to server and it will handle movement
	# the changing position will come back through the synchronizer
	if not multiplayer.is_server():
		handle_input.rpc_id(1, Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")))
	move_and_slide()

@rpc("any_peer", "call_remote", "unreliable")
func handle_input(dierection : Vector2):  
	# when the client sends input 
	if assigned_net_id == multiplayer.get_remote_sender_id():
		velocity = dierection.normalized() * SPEED
