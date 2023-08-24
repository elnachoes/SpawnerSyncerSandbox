class_name Player
extends CharacterBody2D

const SPEED = 300.0

var assigned_net_id = 0

func is_controlled_by_server() -> bool : return multiplayer.is_server() and assigned_net_id == 1

func _physics_process(_delta):
	# if the player is a client send the input to server and it will handle movement
	# the changing position will come back through the synchronizer
	var input_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	if is_controlled_by_server():
		handle_input(input_direction)
	
	if multiplayer.is_server():
		move_and_slide()
	else:
		handle_input.rpc_id(1, input_direction)

@rpc("any_peer", "call_remote", "unreliable")
func handle_input(input_direction : Vector2):  
	if multiplayer.get_remote_sender_id() == assigned_net_id or is_controlled_by_server():
		velocity = input_direction.normalized() * SPEED
