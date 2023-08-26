class_name Player
extends CharacterBody2D

const SPEED = 300.0

@export var input_peer_id := 1

@onready var label := $Label as Label
@onready var inputs := $Inputs as PlayerInputs


func _ready():
	inputs.set_multiplayer_authority(input_peer_id)
	
	label.text = str(input_peer_id)
	if multiplayer.get_unique_id() == input_peer_id:
		label.text += " (you)"


func _physics_process(_delta):
	if multiplayer.is_server():
		velocity = inputs.direction.normalized() * SPEED
		move_and_slide()
