class_name MultiTargetCamera
extends Camera2D

@export var target_size := Vector2(128, 128)
@export_range(0.1, 1) var margin := 0.75
@export_range(0, 1) var zoom_lerp := 0.05


func show_all_targets(targets: Array):
	var num_targets := targets.size()
	if num_targets == 0:
		return
	
	var min_bound := Vector2(INF, INF)
	var max_bound := Vector2(-INF, -INF)

	for target in targets:
		min_bound.x = min(min_bound.x, target.position.x)
		min_bound.y = min(min_bound.y, target.position.y)
		
		max_bound.x = max(max_bound.x, target.position.x)
		max_bound.y = max(max_bound.y, target.position.y)
	
	position = (min_bound + max_bound) / 2
	
	var window_size := Vector2(DisplayServer.window_get_size())
	var view_size := (max_bound - position) * 2
	
	var ratio = window_size / (view_size + target_size)
	var best_ratio = min(ratio.x, ratio.y) * margin
	
	var new_zoom := Vector2(best_ratio, best_ratio).clamp(Vector2.ZERO, Vector2.ONE)
	zoom = zoom.lerp(new_zoom, zoom_lerp)
