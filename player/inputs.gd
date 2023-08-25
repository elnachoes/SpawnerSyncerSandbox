class_name PlayerInputs
extends Node

@export var direction = Vector2()


func _physics_process(_delta):
	if is_multiplayer_authority():
		direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
