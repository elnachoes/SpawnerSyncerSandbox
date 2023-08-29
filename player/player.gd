class_name Player
extends CharacterBody2D

const SPEED = 300.0
const position_lerp = 0.5

@export var input_peer_id := 1
@export var synced_position := position
@export var sync_number := 0

@onready var label := $Label as Label
@onready var input := $Input as PlayerInput


func _ready():
	input.set_multiplayer_authority(input_peer_id)
	input.syncer.set_visibility_for(1, true)
	
	label.text = str(input_peer_id)
	if multiplayer.get_unique_id() == input_peer_id:
		label.text += " (you)"


func _physics_process(_delta):
	if multiplayer.is_server():
		velocity = input.direction.normalized() * SPEED
		move_and_slide()
		
		synced_position = position
		sync_number = input.sync_number
	else:
		if multiplayer.get_unique_id() == input_peer_id:
			synced_position = predict_and_reconcile(synced_position)
		
		position = position.lerp(synced_position, position_lerp)


func predict_and_reconcile(pos: Vector2) -> Vector2:
	input.history = input.history.filter(func(record: PlayerInput.InputRecord):
		if record.sync_number > sync_number:
			pos += record.direction.normalized() * SPEED * record.delta
			return true
		return false
	)
	
	return pos
