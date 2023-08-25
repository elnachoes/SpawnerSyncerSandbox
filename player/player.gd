class_name Player
extends CharacterBody2D

const SPEED = 300.0

@export var input_peer_id := 1

@onready var inputs := $Inputs as PlayerInputs


func _ready():
	inputs.set_multiplayer_authority(input_peer_id)


func _physics_process(_delta):
	if multiplayer.is_server():
		velocity = inputs.direction.normalized() * SPEED
		move_and_slide()
