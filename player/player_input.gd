class_name PlayerInput
extends Node

@export var direction := Vector2()
@export var sync_number := 0

@onready var syncer := $InputSyncer as MultiplayerSynchronizer

var history: Array[InputRecord] = []


func _physics_process(delta):
	if is_multiplayer_authority():
		direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
		if not multiplayer.is_server():
			sync_number += 1
			history.append(InputRecord.new(direction, sync_number, delta))


class InputRecord:
	var direction: Vector2
	var sync_number: int
	var delta: float
	
	func _init(init_direction: Vector2, init_sync_number: int, init_delta: float):
		self.direction = init_direction
		self.sync_number = init_sync_number
		self.delta = init_delta
